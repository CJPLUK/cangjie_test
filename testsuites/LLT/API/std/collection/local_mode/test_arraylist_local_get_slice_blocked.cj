/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// UPDATE 2026-09-11: SDK local_mode-localmods-20260911-final 已修复本文件原阻塞器，恢复 EXEC（原阻塞记录见下）。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// BLOCKED (LM-DOC-20260910 T306, C3/SDK symbol gap): local ArrayList slice and
// range-index calls are accepted by the frontend, but the 0907 SDK links no
// local ArrayList slice/range symbols.  Keep the doc-correct open/closed,
// omitted-end, step-two and exception expectations until SDK alignment.

import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0
    let source: Array<Int64> @local! = [1, 2, 3, 4, 5]
    let bang: ArrayList<Int64> @local! = ArrayList<Int64>(source) @local!
    let question: ArrayList<Int64> @local? = bang
    let open: ArrayList<Int64> @local! = bang.slice(1..3)
    let closed: ArrayList<Int64> @local! = bang[1..=2]
    let omitted: ArrayList<Int64> @local! = bang.slice(Range<Int64>(0, 3, 1, false, true, false))
    let qOpen: ArrayList<Int64> @local? = question[1..3]
    failed += assertEq(open.size, 2, "T306_open_size")
    failed += assertEq(open[0], 2, "T306_open_0")
    failed += assertEq(open[1], 3, "T306_open_1")
    failed += assertEq(closed.size, 2, "T306_closed_size")
    failed += assertEq(closed[0], 2, "T306_closed_0")
    failed += assertEq(closed[1], 3, "T306_closed_1")
    failed += assertEq(omitted.size, 3, "T306_omitted_size")
    failed += assertEq(qOpen.size, 2, "T306_question_open_size")
    try {
        let _ = bang.slice(-1..1)
        failed += 1
        println("FAIL: T306_negative_start — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        let _ = bang.slice(3..2)
        failed += 1
        println("FAIL: T306_reverse_range — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        let _ = bang.slice(0..6)
        failed += 1
        println("FAIL: T306_end_oob — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        let _ = bang.slice(0..5 : 2)
        failed += 1
        println("FAIL: T306_step2_illegal — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
