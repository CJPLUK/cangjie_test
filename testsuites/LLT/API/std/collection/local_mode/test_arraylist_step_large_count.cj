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

func checkContents(actual: ArrayList<Int64> @local?, expected: Array<Int64>): Unit {
    check(actual.size == expected.size, "step logical size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "step payload") }
}

func checkHeapContents(actual: ArrayList<Int64>, expected: Array<Int64>): Unit {
    check(actual.size == expected.size, "heap step logical size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "heap step payload") }
}

func checkOwned(count: Int64): Unit {
    let source: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    let empty: ArrayList<Int64> @local! = source.step(count)
    checkContents(empty, [])
    source.add(1); source.add(2); source.add(3); source.add(4)
    let result: ArrayList<Int64> @local! = source.step(count)
    checkContents(result, [1])
    result[0] = 99
    checkContents(source, [1, 2, 3, 4])
}

func checkHeap(count: Int64): Unit {
    let source = ArrayList<Int64>(16)
    let empty: ArrayList<Int64> = source.step(count)
    checkHeapContents(empty, [])
    source.add(1); source.add(2); source.add(3); source.add(4)
    let result: ArrayList<Int64> = source.step(count)
    checkHeapContents(result, [1])
    result[0] = 99
    checkHeapContents(source, [1, 2, 3, 4])
}

main(): Int64 {
    var failed = 0
    for (count in [5, Int64.Max - 3, Int64.Max - 2, Int64.Max]) {
        try { checkHeap(count) }
        catch (e: Exception) { println("heap step=" + count.toString() + ": " + e.message); failed++ }
        try { checkOwned(count) }
        catch (e: Exception) { println("local step=" + count.toString() + ": " + e.message); failed++ }
    }
    if (failed != 0) { return 1 }
    println("ALL PASSED")
    0
}
