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
// Regression guard for the quadratic copy/allocation defect in
// `ArrayList.flatMap(this @local!)`.
//
// Defect shape (stdlib/libs/std/collection/array_list.cj, before the fix):
//
//     var newData: Array<R> @local! = Array<R>(0, repeat: ...)
//     for (i in 0..mySize) {
//         let sz = tempData.size
//         let newArr = Array<R>(oldLen + sz, repeat: ...)   // full rebuild per round
//         newData.copyTo(newArr, 0, 0, oldLen)              // re-copies all previous output
//         tempData.myData.copyTo(newArr, 0, oldLen, sz)
//         newData = newArr
//     }
//
// Every round re-copies the accumulated prefix, so the total work is O(n^2)
// element copies plus O(n) whole-buffer allocations. Measured with a transform
// returning one element per input: n=4000 passed, n=8000 aborted with
// `IndexOutOfBoundsException: SrcStart is greater than or equal to the size of
// this array` at roughly 53 MB peak RSS. After the fix n=8000 must return
// normally with a far lower peak.
//
// The assertions below cover observable behaviour only (exact contents plus the
// large-n cases not aborting); no timing assertion is made so the case does not
// flake on slow machines.

import std.collection.*
import std.core.*

// Returns a single-element ArrayList holding the input.
exclave func oneElement(v: Int64 @local!): ArrayList<Int64> @local! {
    let a: ArrayList<Int64> @local! = ArrayList<Int64>(1) @local!
    a.add(v)
    a
}

// Returns an empty ArrayList. A named exclave function is required because a
// lambda body cannot return an `@local!` value.
exclave func emptyResult(_: Int64 @local!): ArrayList<Int64> @local! {
    ArrayList<Int64>(0) @local!
}

// Returns three elements per input, used to verify concatenation order.
exclave func threeElements(v: Int64 @local!): ArrayList<Int64> @local! {
    let a: ArrayList<Int64> @local! = ArrayList<Int64>(3) @local!
    a.add(v)
    a.add(v * 10)
    a.add(v * 100)
    a
}

main(): Int64 {
    var failed = 0

    // Small input: exact contents and ordering.
    let small: ArrayList<Int64> @local! = ArrayList<Int64>(4) @local!
    for (i in 0..4) { small.add(i) }
    let flatSmall: ArrayList<Int64> @local! = small.flatMap<Int64>(threeElements)
    failed += assertEq(flatSmall.size, 12, "FM_small_size")
    let expected: Array<Int64> = [0, 0, 0, 1, 10, 100, 2, 20, 200, 3, 30, 300]
    var ok = true
    for (i in 0..12) {
        if (flatSmall[i] != expected[i]) { ok = false }
    }
    failed += assertB(ok, "FM_small_order")

    // Empty source.
    let emptySrc: ArrayList<Int64> @local! = ArrayList<Int64>(0) @local!
    let flatEmpty: ArrayList<Int64> @local! = emptySrc.flatMap<Int64>(threeElements)
    failed += assertEq(flatEmpty.size, 0, "FM_empty_source")

    // Transform always returns empty: the result must be empty.
    let someSrc: ArrayList<Int64> @local! = ArrayList<Int64>(3) @local!
    for (i in 0..3) { someSrc.add(i) }
    let flatAllEmpty: ArrayList<Int64> @local! = someSrc.flatMap<Int64>(emptyResult)
    failed += assertEq(flatAllEmpty.size, 0, "FM_all_empty_results")

    // Large input: the core regression point (n=8000 aborted before the fix).
    let big: ArrayList<Int64> @local! = ArrayList<Int64>(8000) @local!
    for (i in 0..8000) { big.add(i) }
    let flatBig: ArrayList<Int64> @local! = big.flatMap<Int64>(oneElement)
    failed += assertEq(flatBig.size, 8000, "FM_large_8000_size")
    failed += assertEq(flatBig[7999], 7999, "FM_large_8000_last")

    // Large input with three elements each: 24000 accumulated.
    let flatHuge: ArrayList<Int64> @local! = big.flatMap<Int64>(threeElements)
    failed += assertEq(flatHuge.size, 24000, "FM_large_24000_size")
    failed += assertEq(flatHuge[23999], 799900, "FM_large_24000_last")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
