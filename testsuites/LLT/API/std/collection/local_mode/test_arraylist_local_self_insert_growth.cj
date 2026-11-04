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

func checkSelfInsertion(capacity: Int64, at: Int64): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(capacity) @local!
    list.add(1); list.add(2); list.add(3)
    let oldIterator: Iterator<Int64> @local! = list.iterator()
    list.add(all: list, at: at)
    let expected = if (at == 1) { [1, 1, 2, 3, 2, 3] } else { [1, 2, 3, 1, 2, 3] }
    check(list.size == 6, "self insertion size")
    let iterator: Iterator<Int64> @local! = list.iterator()
    for (i in 0..expected.size) {
        check(list[i] == expected[i], "self insertion must read the original source contents")
        check(iterator.next().getOrThrow() == expected[i], "self insertion iterator payload")
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "iterator remains exhausted")
    var caught = false
    try { let _ = oldIterator.next() }
    catch (_: ConcurrentModificationException) { caught = true }
    check(caught, "self insertion invalidates an existing iterator")
}

func checkHeapSelfInsertion(capacity: Int64, at: Int64): Unit {
    let list = ArrayList<Int64>(capacity)
    list.add(1); list.add(2); list.add(3)
    let oldIterator = list.iterator()
    list.add(all: list, at: at)
    let expected = if (at == 1) { [1, 1, 2, 3, 2, 3] } else { [1, 2, 3, 1, 2, 3] }
    check(list.size == expected.size, "heap self insertion size")
    let iterator = list.iterator()
    for (i in 0..expected.size) {
        check(list[i] == expected[i] && iterator.next().getOrThrow() == expected[i], "heap self insertion payload")
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "heap self insertion iterator exhaustion")
    var caught = false
    try { let _ = oldIterator.next() }
    catch (_: ConcurrentModificationException) { caught = true }
    check(caught, "heap self insertion invalidates the old iterator")
}

main(): Int64 {
    var failed = 0
    for (capacity in [3, 16]) {
        for (at in [0, 1, 3]) {
            try { checkHeapSelfInsertion(capacity, at) }
            catch (e: Exception) {
                println("heap capacity=" + capacity.toString() + " at=" + at.toString() + ": " + e.message)
                failed++
            }
            try { checkSelfInsertion(capacity, at) }
            catch (e: Exception) {
                println("capacity=" + capacity.toString() + " at=" + at.toString() + ": " + e.message)
                failed++
            }
        }
    }
    if (failed != 0) { return 1 }
    println("ALL PASSED")
    0
}
