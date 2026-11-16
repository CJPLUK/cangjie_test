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
// FIXED（2026-09-24）：原 BLOCKED（设计项 LM-DOC-20260910：T118/T119/T120）三项
//   阻塞均已在当前 SDK/runtime 解决——T118 的 Option<T> @local!/@local? Some payload
//   写入、T119 的 non-Copyable String [] 读取、T120 的 Array<T>::operator[](Range)
//   local 符号链接均正常，本用例恢复活跃并实测 ALL PASSED。T120 的 step=1 断言
//   已按原文恢复为活跃代码；step=2 探针保持注释（运行时按文档语义抛
//   IllegalArgumentException "Illegal step 2, step should be 1"，SKIPPED 注释保留）。

func dynamicGetNegative(): Int64 {
    -1
}

func dynamicGetSize(): Int64 {
    2
}

main(): Int64 {
    var failed = 0

    // T118: first/last four mode slots and empty None. None has no payload and is
    // expected to remain observable even while Some construction is blocked.
    let empty118Bang: Array<Int64> @local! = Array<Int64>()
    let empty118Question: Array<Int64> @local? = Array<Int64>()
    let emptyFirst118Bang: Option<Int64> @local! = empty118Bang.first
    let emptyLast118Bang: Option<Int64> @local! = empty118Bang.last
    let emptyFirst118Question: Option<Int64> @local? = empty118Question.first
    let emptyLast118Question: Option<Int64> @local? = empty118Question.last
    match (emptyFirst118Bang) {
        case None => failed += assertB(true, "T118_empty_first_localBang_none")
        case Some(_) =>
            failed += 1
            println("FAIL: T118_empty_first_localBang_none — expected None")
    }
    match (emptyLast118Bang) {
        case None => failed += assertB(true, "T118_empty_last_localBang_none")
        case Some(_) =>
            failed += 1
            println("FAIL: T118_empty_last_localBang_none — expected None")
    }
    match (emptyFirst118Question) {
        case None => failed += assertB(true, "T118_empty_first_localQuestion_none")
        case Some(_) =>
            failed += 1
            println("FAIL: T118_empty_first_localQuestion_none — expected None")
    }
    match (emptyLast118Question) {
        case None => failed += assertB(true, "T118_empty_last_localQuestion_none")
        case Some(_) =>
            failed += 1
            println("FAIL: T118_empty_last_localQuestion_none — expected None")
    }

    // T118: exact Some payloads in each mode. The first Some call is intentionally
    // left executable so the disabled case proves the current runtime blocker.
    let values118Bang: Array<Int64> @local! = [7, 8]
    let values118Question: Array<Int64> @local? = [7, 8]
    let first118Bang: Option<Int64> @local! = values118Bang.first
    match (first118Bang) {
        case Some(value) => failed += assertEq(value, 7, "T118_first_localBang_some_7")
        case None =>
            failed += 1
            println("FAIL: T118_first_localBang_some_7 — expected Some(7)")
    }
    let last118Bang: Option<Int64> @local! = values118Bang.last
    match (last118Bang) {
        case Some(value) => failed += assertEq(value, 8, "T118_last_localBang_some_8")
        case None =>
            failed += 1
            println("FAIL: T118_last_localBang_some_8 — expected Some(8)")
    }
    let first118Question: Option<Int64> @local? = values118Question.first
    match (first118Question) {
        case Some(value) => failed += assertEq(value, 7, "T118_first_localQuestion_some_7")
        case None =>
            failed += 1
            println("FAIL: T118_first_localQuestion_some_7 — expected Some(7)")
    }
    let last118Question: Option<Int64> @local? = values118Question.last
    match (last118Question) {
        case Some(value) => failed += assertEq(value, 8, "T118_last_localQuestion_some_8")
        case None =>
            failed += 1
            println("FAIL: T118_last_localQuestion_some_8 — expected Some(8)")
    }

    // T119: get() distinguishes None from []'s strict IndexOutOfBoundsException;
    // dynamic indices avoid compile-time constant folding.
    let values119: Array<String> @local! = ["ab", "cd"]
    let values119Question: Array<String> @local? = ["ab", "cd"]
    let negative119 = dynamicGetNegative()
    let size119 = dynamicGetSize()
    let getNegative119: Option<String> @local! = values119.get(negative119)
    let getSize119: Option<String> @local? = values119Question.get(size119)
    match (getNegative119) {
        case None => failed += assertB(true, "T119_get_negative_none")
        case Some(_) =>
            failed += 1
            println("FAIL: T119_get_negative_none — expected None")
    }
    match (getSize119) {
        case None => failed += assertB(true, "T119_get_size_none")
        case Some(_) =>
            failed += 1
            println("FAIL: T119_get_size_none — expected None")
    }
    let value119Bang: String @local! = values119[0]
    failed += assertB(value119Bang == "ab", "T119_index_localBang_value")
    let value119Question: String @local? = values119Question[1]
    failed += assertB(value119Question == "cd", "T119_index_localQuestion_value")
    try {
        let _ = values119[negative119]
        failed += 1
        println("FAIL: T119_index_negative — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        let _ = values119Question[size119]
        failed += 1
        println("FAIL: T119_index_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}

    // T120: range getter is a positive local-mode declaration. Half-open, closed
    // and stepped ranges all resolve to the local getter and return a local view.
     let source120Bang: Array<Int64> @local! = [0, 1, 2, 3]
     let halfOpen120Bang: Array<Int64> @local! = source120Bang[1..3]
     failed += assertEq(halfOpen120Bang.size, 2, "T120_bang_half_open_size")
     failed += assertEq(halfOpen120Bang[0], 1, "T120_bang_half_open_0")
     let closed120Bang: Array<Int64> @local! = source120Bang[1..=2]
     failed += assertEq(closed120Bang[1], 2, "T120_bang_closed_1")
    // 步长非 1 的 range 在 local getter 上被拒绝（IllegalArgumentException），
    // 与 heap 路径一致。
    let stepped120Bang: Range<Int64> = Range<Int64>(0, 4, 2, true, false, false)
    try {
        let _ = source120Bang[stepped120Bang]
        failed += 1
        println("FAIL: T120_bang_step — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
     let source120Question: Array<Int64> @local? = [0, 1, 2, 3]
     let halfOpen120Question: Array<Int64> @local? = source120Question[1..3]
     failed += assertEq(halfOpen120Question[0], 1, "T120_question_half_open_0")
    // T120 越界与非法 range 边界：与 heap 路径一致抛 IndexOutOfBoundsException。
    let outOfBounds120: Array<Range<Int64>> = [3..2, 1..5, -1..2]
    for (r in outOfBounds120) {
        try {
            let _ = source120Bang[r]
            failed += 1
            println("FAIL: T120_bang_range — expected IndexOutOfBoundsException")
        } catch (e: IndexOutOfBoundsException) {}
        try {
            let _ = source120Question[r]
            failed += 1
            println("FAIL: T120_question_range — expected IndexOutOfBoundsException")
        } catch (e: IndexOutOfBoundsException) {}
    }

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
