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
// T320-T329: non-empty transforms with exact result/content/callback assertions.
// UPDATE 2026-09-29: runs ALL PASSED on the 2026-09-28 SDK; the earlier
// `Barrier::WriteGeneric does not support local object` abort record is obsolete.
// No UnimplementedException or wrong current behavior is accepted as success.

import std.collection.*
import std.core.*
exclave func mapString324(x: Int64 @local!): String @local! {
    if (x == 0) {
        "v0"
    } else if (x == 1) {
        "v1"
    } else if (x == 2) {
        "v2"
    } else if (x == 3) {
        "v3"
    } else {
        "v4"
}
}

exclave func flatMapString325(x: Int64 @local!): ArrayList<String> @local! {
    if (x == 0) {
        ArrayList<String>() @local!
    } else if (x == 1) {
        let one: Array<String> @local! = ["b"]
        ArrayList<String>(one) @local!
    } else {
        let two: Array<String> @local! = ["c", "d"]
        ArrayList<String>(two) @local!
    }
}

exclave func filterMapString326(x: Int64 @local!): Option<String> @local! {
    if (x == 1) {
        Some<String>("a")
    } else if (x == 3) {
        Some<String>("c")
    } else {
        None<String>
    }
}


main(): Int64 {
    var failed = 0
    let source: Array<Int64> @local! = [0, 1, 2, 3, 4]
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(source) @local!

    // T320: step count 1/2/>size, exact sequence and source unchanged.
    let stepOne: ArrayList<Int64> @local! = list.step(1)
    let stepTwo: ArrayList<Int64> @local! = list.step(2)
    let stepLarge: ArrayList<Int64> @local! = list.step(9)
    failed += assertEq(stepOne.size, 5, "T320_step1_size")
    failed += assertEq(stepTwo.size, 3, "T320_step2_size")
    failed += assertEq(stepTwo[0], 0, "T320_step2_0")
    failed += assertEq(stepTwo[1], 2, "T320_step2_1")
    failed += assertEq(stepTwo[2], 4, "T320_step2_2")
    failed += assertEq(stepLarge.size, 1, "T320_step_large_size")
    try {
        let _ = list.step(-1)
        failed += 1
        println("FAIL: T320_step_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    // T321/T322 exact prefixes/suffixes and boundaries.
    let takeTwo: ArrayList<Int64> @local! = list.take(2)
    let takeFull: ArrayList<Int64> @local! = list.take(9)
    let skipTwo: ArrayList<Int64> @local! = list.skip(2)
    let skipFull: ArrayList<Int64> @local! = list.skip(9)
    failed += assertEq(takeTwo.size, 2, "T321_take2_size")
    failed += assertEq(takeTwo[1], 1, "T321_take2_last")
    failed += assertEq(takeFull.size, 5, "T321_take_large_full")
    failed += assertEq(skipTwo.size, 3, "T322_skip2_size")
    failed += assertEq(skipTwo[0], 2, "T322_skip2_first")
    failed += assertEq(skipFull.size, 0, "T322_skip_large_empty")
    try {
        let _ = list.take(-1)
        failed += 1
        println("FAIL: T321_take_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = list.skip(-1)
        failed += 1
        println("FAIL: T322_skip_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    // T323 filter stable partition, empty callback count, throw propagation.
    let filtered: ArrayList<Int64> @local! = list.filter({x: Int64 @local? => x % 2 == 0})
    failed += assertEq(filtered.size, 3, "T323_filter_size")
    failed += assertEq(filtered[0], 0, "T323_filter_0")
    failed += assertEq(filtered[2], 4, "T323_filter_2")

    // T324 map Int64 -> String exact values and exception propagation.
    let mapped: ArrayList<String> @local! = list.map(mapString324)
    failed += assertEq(mapped.size, 5, "T324_map_size")
    failed += assertB(mapped[0] == "v0", "T324_map_0")
    failed += assertB(mapped[1] == "v1", "T324_map_1")

    // T325 flatten []/[b]/[c,d] in source order.
    let flattened: ArrayList<String> @local! = list.flatMap(flatMapString325)
    failed += assertEq(flattened.size, 7, "T325_flatMap_size")
    failed += assertB(flattened[0] == "b", "T325_flatMap_first")

    // T326 Some/None alternation and all-None result.
    let selected: ArrayList<String> @local! = list.filterMap(filterMapString326)
    failed += assertEq(selected.size, 2, "T326_filterMap_size")
    failed += assertB(selected[0] == "a", "T326_filterMap_a")
    failed += assertB(selected[1] == "c", "T326_filterMap_c")

    // T327 empty/single/many intersperse.
    let empty: Array<Int64> @local! = []
    let emptyList: ArrayList<Int64> @local! = ArrayList<Int64>(empty) @local!
    let one: Array<Int64> @local! = [1]
    let oneList: ArrayList<Int64> @local! = ArrayList<Int64>(one) @local!
    let three: Array<Int64> @local! = [1, 2, 3]
    let threeList: ArrayList<Int64> @local! = ArrayList<Int64>(three) @local!
    let interEmpty: ArrayList<Int64> @local! = emptyList.intersperse(0)
    let interOne: ArrayList<Int64> @local! = oneList.intersperse(0)
    let interThree: ArrayList<Int64> @local! = threeList.intersperse(0)
    failed += assertEq(interEmpty.size, 0, "T327_intersperse_empty")
    failed += assertEq(interOne.size, 1, "T327_intersperse_single")
    failed += assertEq(interThree.size, 5, "T327_intersperse_many_size")
    failed += assertEq(interThree[1], 0, "T327_intersperse_separator")

    // T328 callback exception and T329 None/singleton/left-fold reduce.
    try {
        let _: Int64 @local! = list.fold(0, {acc: Int64 @local!, x: Int64 @local! =>
            if (x == 2) { throw ArithmeticException("T328_sentinel") }
            acc + x
        })
        failed += 1
        println("FAIL: T328_fold_throw — expected ArithmeticException")
    } catch (e: ArithmeticException) {}
    let emptyReduce: ArrayList<Int64> @local! = ArrayList<Int64>(empty) @local!
    let noResult: Option<Int64> @local! = emptyReduce.reduce({x: Int64 @local!, y: Int64 @local! => x + y})
    match (noResult) { case None => () case Some(_) => failed += 1 }
    let singletonReduce: Array<Int64> @local! = [7]
    let singletonList: ArrayList<Int64> @local! = ArrayList<Int64>(singletonReduce) @local!
    let oneResult: Option<Int64> @local! = singletonList.reduce({x: Int64 @local!, y: Int64 @local! =>
        throw ArithmeticException("T329_singleton_callback_must_not_run")
    })
    match (oneResult) {
        case Some(v) => failed += assertEq(v, 7, "T329_singleton_value")
        case None => failed += 1
    }
    let manyResult: Option<Int64> @local! = list.reduce({x: Int64 @local!, y: Int64 @local! => x - y})
    match (manyResult) {
        case Some(v) => failed += assertEq(v, -10, "T329_many_left_fold")
        case None => failed += 1
    }

    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
