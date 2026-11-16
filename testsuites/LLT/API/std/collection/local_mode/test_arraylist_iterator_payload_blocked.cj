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
// BLOCKED (LM-DOC-20260910 T307, C7/runtime barrier): bang/q iterators must
// return exact Int64 Some payloads for empty/single/many and then stable None
// twice.  The 0907 SDK aborts in Iterator.next while materializing a local
// Some payload (`F Barrier::WriteGeneric does not support local object`).

import std.collection.*
import std.core.*

func checkBang(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        let first: Option<Int64> @local! = it.next()
        var seen: Int64 = 0
        match (first) {
            case Some(v) => seen += assertEq(v, 1, "T307_bang_first")
            case None => seen += 1
        }
        let second: Option<Int64> @local! = it.next()
        match (second) {
            case Some(v) => seen += assertEq(v, 2, "T307_bang_second")
            case None => seen += 1
        }
        let third: Option<Int64> @local! = it.next()
        match (third) {
            case Some(v) => seen += assertEq(v, 3, "T307_bang_third")
            case None => seen += 1
        }
        let none1: Option<Int64> @local! = it.next()
        let none2: Option<Int64> @local! = it.next()
        match (none1) {
            case None => ()
            case Some(_) => seen += 1
        }
        match (none2) {
            case None => ()
            case Some(_) => seen += 1
        }
        seen
    }
}

func checkQuestion(a: ArrayList<Int64> @local?): Int64 {
    let it: Iterator<Int64> @local? = a.iterator()
    let first: Option<Int64> @local? = it.next()
    let second: Option<Int64> @local? = it.next()
    var seen: Int64 = 0
    match (first) {
        case Some(v) => seen += assertEq(v, 1, "T307_question_first")
        case None => seen += 1
    }
    match (second) {
        case Some(v) => seen += assertEq(v, 2, "T307_question_second")
        case None => seen += 1
    }
    seen
}

main(): Int64 {
    var failed = 0
    let oneSource: Array<Int64> @local! = [1]
    let one: ArrayList<Int64> @local! = ArrayList<Int64>(oneSource) @local!
    let manySource: Array<Int64> @local! = [1, 2, 3]
    let many: ArrayList<Int64> @local! = ArrayList<Int64>(manySource) @local!
    let manyQuestion: ArrayList<Int64> @local? = many
    // Singleton checks exact Some then two None; many checks full sequence.
    let singleIt: Iterator<Int64> @local! = one.iterator()
    let single: Option<Int64> @local! = singleIt.next()
    match (single) {
        case Some(v) => failed += assertEq(v, 1, "T307_singleton_payload")
        case None => failed += 1
        println("FAIL: T307_singleton_payload — expected Some(1)")
    }
    let singleNone1: Option<Int64> @local! = singleIt.next()
    let singleNone2: Option<Int64> @local! = singleIt.next()
    match (singleNone1) { case None => () case Some(_) => failed += 1 }
    match (singleNone2) { case None => () case Some(_) => failed += 1 }
    failed += assertEq(checkBang(many), 0, "T307_bang_many_sequence")
    failed += assertEq(checkQuestion(manyQuestion), 0, "T307_question_many_sequence")
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
