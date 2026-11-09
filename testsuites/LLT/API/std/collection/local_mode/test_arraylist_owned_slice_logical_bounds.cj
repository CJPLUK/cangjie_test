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

func checkRejectedClosedEnd(size: Int64, useOperator: Bool): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    for (i in 0..size) { list.add(i + 1) }
    let iterator: Iterator<Int64> @local! = list.iterator()
    var caught = false
    try {
        if (useOperator) { let _: ArrayList<Int64> @local! = list[0..=size] }
        else { let _: ArrayList<Int64> @local! = list.slice(0..=size) }
    } catch (_: IndexOutOfBoundsException) { caught = true }
    check(caught, "owned closed slice must reject its logical end despite spare capacity")
    check(list.size == size, "rejected slice must preserve source size")
    for (i in 0..size) {
        check(list[i] == i + 1 && iterator.next().getOrThrow() == i + 1,
            "rejected slice must preserve contents and iterator validity")
    }
    check(iterator.next().isNone(), "source iterator exhaustion")
}

func checkValidSlices(): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    list.add(1); list.add(2); list.add(3)
    let closed: ArrayList<Int64> @local! = list.slice(0..=2)
    let whole: ArrayList<Int64> @local! = list[..]
    let empty: ArrayList<Int64> @local! = list[3..3]
    check(closed.size == 3 && whole.size == 3 && empty.isEmpty(), "valid owned slice sizes")
    for (i in 0..3) { check(closed[i] == i + 1 && whole[i] == i + 1, "valid owned slice payload") }
    let shared: ArrayList<Int64> @local? = list
    var caught = false
    try { let _: ArrayList<Int64> @local? = shared.slice(0..=3) }
    catch (_: IndexOutOfBoundsException) { caught = true }
    check(caught, "shared slice control must reject the same closed end")
}

func checkHeapClosedEnd(size: Int64, useOperator: Bool): Unit {
    let list = ArrayList<Int64>(16)
    for (i in 0..size) { list.add(i + 1) }
    let iterator = list.iterator()
    var caught = false
    try {
        if (useOperator) { let _ = list[0..=size] }
        else { let _ = list.slice(0..=size) }
    } catch (_: IndexOutOfBoundsException) { caught = true }
    check(caught && list.size == size, "heap closed slice must reject its logical end")
    for (i in 0..size) {
        check(list[i] == i + 1 && iterator.next().getOrThrow() == i + 1, "heap rejected slice preserves its source")
    }
    check(iterator.next().isNone(), "heap source iterator exhaustion")
    let empty = list.slice(size..size)
    check(empty.isEmpty(), "heap open slice at the logical end is empty")
}

main(): Int64 {
    checkValidSlices()
    var failed = 0
    for (size in [0, 1, 3]) {
        for (useOperator in [false, true]) {
            try { checkHeapClosedEnd(size, useOperator) }
            catch (e: Exception) {
                println("heap size=" + size.toString() + ": " + e.message)
                failed++
            }
            try { checkRejectedClosedEnd(size, useOperator) }
            catch (e: Exception) {
                println("size=" + size.toString() + " operator=" + useOperator.toString() + ": " + e.message)
                failed++
            }
        }
    }
    if (failed != 0) { return 1 }
    println("ALL PASSED")
    0
}
