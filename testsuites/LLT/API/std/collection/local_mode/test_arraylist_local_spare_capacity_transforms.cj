/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.collection.*

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkContents(list: ArrayList<Int64> @local?, expected: Array<Int64>): Unit {
    check(list.size == expected.size, "logical size must not include unused capacity")
    for (i in 0..expected.size) { check(list[i] == expected[i], "transform payload and order") }
}

func checkHeapContents(list: ArrayList<Int64>, expected: Array<Int64>): Unit {
    check(list.size == expected.size, "heap logical size must not include unused capacity")
    for (i in 0..expected.size) { check(list[i] == expected[i], "heap transform payload and order") }
}

func checkTransform(capacity: Int64, size: Int64, insertSeparator: Bool): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(capacity) @local!
    for (i in 0..size) { list.add(i + 1) }
    let source = Array<Int64>(size, {i => i + 1})
    let result: ArrayList<Int64> @local! = if (insertSeparator) {
        list.intersperse(9)
    } else {
        list.skip(0)
    }
    checkContents(list, source)
    let expected = if (!insertSeparator || size < 2) { source } else { [1, 9, 2, 9, 3] }
    checkContents(result, expected)
    if (size > 0) {
        result[0] = 99
        checkContents(list, source)
    }
}

func checkHeapTransform(capacity: Int64, size: Int64, insertSeparator: Bool): Unit {
    let list = ArrayList<Int64>(capacity)
    for (i in 0..size) { list.add(i + 1) }
    let source = Array<Int64>(size, {i => i + 1})
    let result: ArrayList<Int64> = if (insertSeparator) { list.intersperse(9) } else { list.skip(0) }
    let expected = if (!insertSeparator || size < 2) { source } else { [1, 9, 2, 9, 3] }
    checkHeapContents(result, expected)
    if (size > 0) { result[0] = 99 }
    checkHeapContents(list, source)
}

main(): Int64 {
    var failed = 0
    for (capacity in [4, 16]) {
        for (size in [0, 1, 3]) {
            for (separator in [false, true]) {
                try { checkHeapTransform(capacity, size, separator) }
                catch (e: Exception) {
                    println("heap capacity=" + capacity.toString() + " size=" + size.toString() + ": " + e.message)
                    failed++
                }
                try { checkTransform(capacity, size, separator) }
                catch (e: Exception) {
                    let operation = if (separator) { "intersperse" } else { "skip(0)" }
                    println(operation + " capacity=" + capacity.toString() + " size=" + size.toString() + ": " + e.message)
                    failed++
                }
            }
        }
    }
    if (failed != 0) { return 1 }
    println("ALL PASSED")
    0
}
