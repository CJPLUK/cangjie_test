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
// BLOCKED (LM-DOC-20260910 T301, C3): the 0907 SDK frontend accepts the
// local! size+initElement constructor, but linking reports an undefined
// ArrayList(local!, size, initElement) symbol.  These are doc-correct probes;
// restore EXEC when the SDK exports that overload.

import std.collection.*
import std.core.*

class InitState301 {
    var calls: Int64 = 0
    var trace: Int64 = 0
}

func valueAt301(a: ArrayList<Int64> @local!, index: Int64): Int64 {
    exclave { a[index] }
}

main(): Int64 {
    var failed = 0
    let state: InitState301 = InitState301()
    let empty: ArrayList<Int64> @local! = ArrayList<Int64>(0, {i =>
        state.calls++
        state.trace = state.trace * 10 + i
        i
    }) @local!
    failed += assertEq(empty.size, 0, "T301_size0_size")
    failed += assertEq(state.calls, 0, "T301_size0_callback_count")

    state.calls = 0
    state.trace = 0
    let full: ArrayList<Int64> @local! = ArrayList<Int64>(3, {i =>
        state.calls++
        state.trace = state.trace * 10 + i
        i * 10
    }) @local!
    failed += assertEq(state.calls, 3, "T301_size3_callback_count")
    failed += assertEq(state.trace, 12, "T301_size3_callback_trace")
    failed += assertEq(full.size, 3, "T301_size3_size")
    failed += assertEq(valueAt301(full, 0), 0, "T301_size3_value0")
    failed += assertEq(valueAt301(full, 1), 10, "T301_size3_value1")
    failed += assertEq(valueAt301(full, 2), 20, "T301_size3_value2")

    state.calls = 0
    try {
        let invalid: ArrayList<Int64> @local! = ArrayList<Int64>(-1, {i =>
            state.calls++
            i
        }) @local!
        failed += assertEq(invalid.size, -1, "T301_negative_size_unreachable")
    } catch (e: IllegalArgumentException) {}
    failed += assertEq(state.calls, 0, "T301_negative_size_callback_count")

    state.calls = 0
    state.trace = 0
    try {
        let propagated: ArrayList<Int64> @local! = ArrayList<Int64>(3, {i =>
            state.calls++
            state.trace = state.trace * 10 + i
            if (i == 1) {
                throw ArithmeticException("T301_sentinel")
            }
            i
        }) @local!
        failed += assertEq(propagated.size, -1, "T301_callback_exception_unreachable")
    } catch (e: ArithmeticException) {}
    failed += assertEq(state.calls, 2, "T301_callback_exception_count")
    failed += assertEq(state.trace, 1, "T301_callback_exception_trace")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
