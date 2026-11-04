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
// `Array.flatMap(this @local!)`.
//
// Defect shape (stdlib/libs/std/core/array.cj, before the fix):
//
//     var result: Array<R> @local! = Array<R>()
//     while (i < this.len) {
//         result = result.concat(transform(value))
//         i = i + 1
//     }
//
// `concat` always allocates `this.len + other.len` and copies the whole prefix,
// so every round re-copies the accumulated output and the total work is O(n^2)
// element copies. With a transform returning two elements per input the process
// aborted with SIGSEGV in Array copy: n=1000 passed, while n=2000 and n=3000
// both crashed, which is unusual because it undercuts the sizes that still work
// (the same SIGSEGV also reproduced on the untouched baseline SDK). After the
// fix the buffer grows geometrically and only the newly appended run is copied,
// so n=2000/3000/8000 return 4000/6000/16000 in about 0.01 s at 7-8 MB peak RSS.
//
// The assertions below cover observable behaviour only (exact contents plus the
// large-n cases not aborting); no timing assertion is made so the case does not
// flake on slow machines.

import std.core.*

// Returns two elements per input. A named exclave function is required because
// a lambda body cannot return an `@local!` value.
exclave func twoElements(v: Int64 @local!): Array<Int64> @local! {
    let a: Array<Int64> @local! = Array<Int64>(2, repeat: 0) @local!
    a[0] = v
    a[1] = v * 10
    a
}

// Returns three elements per input, used to verify concatenation order.
exclave func threeElements(v: Int64 @local!): Array<Int64> @local! {
    let a: Array<Int64> @local! = Array<Int64>(3, repeat: 0) @local!
    a[0] = v
    a[1] = v * 10
    a[2] = v * 100
    a
}

// Returns an empty array, so the result buffer must stay empty regardless of n.
exclave func emptyResult(_: Int64 @local!): Array<Int64> @local! {
    Array<Int64>(0, repeat: 0) @local!
}

main(): Int64 {
    var failed = 0

    // Small input: exact contents and ordering.
    let small: Array<Int64> @local! = Array<Int64>(4, repeat: 0) @local!
    for (i in 0..4) { small[i] = i }
    let flatSmall: Array<Int64> @local! = small.flatMap<Int64>(threeElements)
    failed += assertEq(flatSmall.size, 12, "AFM_small_size")
    failed += assertEq(flatSmall[0], 0, "AFM_small_0")
    failed += assertEq(flatSmall[1], 0, "AFM_small_1")
    failed += assertEq(flatSmall[2], 0, "AFM_small_2")
    failed += assertEq(flatSmall[3], 1, "AFM_small_3")
    failed += assertEq(flatSmall[4], 10, "AFM_small_4")
    failed += assertEq(flatSmall[5], 100, "AFM_small_5")
    failed += assertEq(flatSmall[11], 300, "AFM_small_last")

    // Transform returning nothing must yield an empty result for a non-empty input.
    let flatEmpty: Array<Int64> @local! = small.flatMap<Int64>(emptyResult)
    failed += assertEq(flatEmpty.size, 0, "AFM_empty_result")

    // Large input: the pre-fix implementation aborted at these sizes.
    let big: Array<Int64> @local! = Array<Int64>(2000, repeat: 1) @local!
    let flatBig: Array<Int64> @local! = big.flatMap<Int64>(twoElements)
    failed += assertEq(flatBig.size, 4000, "AFM_big_size")
    failed += assertEq(flatBig[0], 1, "AFM_big_first")
    failed += assertEq(flatBig[1], 10, "AFM_big_second")
    failed += assertEq(flatBig[3998], 1, "AFM_big_last_pair")

    // The copy volume must stay linear: 8000 inputs also aborted before the fix.
    let larger: Array<Int64> @local! = Array<Int64>(8000, repeat: 2) @local!
    let flatLarger: Array<Int64> @local! = larger.flatMap<Int64>(twoElements)
    failed += assertEq(flatLarger.size, 16000, "AFM_larger_size")
    failed += assertEq(flatLarger[15999], 20, "AFM_larger_last")

    // Empty input stays empty.
    let none: Array<Int64> @local! = Array<Int64>(0, repeat: 0) @local!
    let flatNone: Array<Int64> @local! = none.flatMap<Int64>(twoElements)
    failed += assertEq(flatNone.size, 0, "AFM_none_size")

    if (failed == 0) {
        println("OK")
        0
    } else {
        failed
    }
}
