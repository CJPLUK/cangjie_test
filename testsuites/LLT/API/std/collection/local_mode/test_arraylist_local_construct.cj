/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// LM-DOC-20260910: T300/T301.  T302 is an independent blocked-positive
// compile probe in test_arraylist_local_collection_construct.cj (C5).
// The read-only construction probes below avoid all post-construction writes.

import std.collection.*
import std.core.*


func sizeOf(a: ArrayList<Int64> @local!): Int64 {
    exclave { a.size }
}

func capacityOf(a: ArrayList<Int64> @local!): Int64 {
    exclave { a.capacity }
}


main(): Int64 {
    var failed = 0

    // T300: default capacity is exactly 16, and explicit capacities are exact.
    let d300: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    failed += assertEq(sizeOf(d300), 0, "T300_default_size")
    failed += assertEq(capacityOf(d300), 16, "T300_default_capacity")

    let c0: ArrayList<Int64> @local! = ArrayList<Int64>(0) @local!
    failed += assertEq(sizeOf(c0), 0, "T300_capacity0_size")
    failed += assertEq(capacityOf(c0), 0, "T300_capacity0_exact")
    let c1: ArrayList<Int64> @local! = ArrayList<Int64>(1) @local!
    failed += assertEq(capacityOf(c1), 1, "T300_capacity1_exact")
    let c16: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    failed += assertEq(capacityOf(c16), 16, "T300_capacity16_exact")
    try {
        let bad: ArrayList<Int64> @local! = ArrayList<Int64>(-1) @local!
        failed += assertEq(bad.size, -1, "T300_negative_capacity_unreachable")
    } catch (e: IllegalArgumentException) {}
    // T301 size+initElement callback paths are retained doc-correct in
    // test_arraylist_local_construct_callback_blocked.cj: this SDK's 0907
    // stdlib links no ArrayList(local!, size, initElement) symbol (C3).



    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
