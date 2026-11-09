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
// LM-DOC-20260910: T307 empty/repeated-exhaustion probe is active.  The
// non-empty Int64 Some payload sequence is doc-correct in
// test_arraylist_iterator_payload_blocked.cj (the 0907 SDK aborts while
// materializing ArrayListIterator.next Some into a local Option).
// T308 write-based fail-fast is isolated in
// test_arraylist_iterator_failfast_blocked.cj.

import std.collection.*
import std.core.*

func bangEmpty(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        let first: Option<Int64> @local! = it.next()
        let second: Option<Int64> @local! = it.next()
        let third: Option<Int64> @local! = it.next()
        var noneCount: Int64 = 0
        match (first) {
            case None => noneCount++
            case Some(_) => ()
        }
        match (second) {
            case None => noneCount++
            case Some(_) => ()
        }
        match (third) {
            case None => noneCount++
            case Some(_) => ()
        }
        noneCount
    }
}

func questionEmpty(a: ArrayList<Int64> @local?): Int64 {
    let it: Iterator<Int64> @local? = a.iterator()
    let first: Option<Int64> @local? = it.next()
    let second: Option<Int64> @local? = it.next()
    var noneCount: Int64 = 0
    match (first) {
        case None => noneCount++
        case Some(_) => ()
    }
    match (second) {
        case None => noneCount++
        case Some(_) => ()
    }
    noneCount
}

main(): Int64 {
    var failed = 0
    let emptySource: Array<Int64> @local! = []
    let emptyBang: ArrayList<Int64> @local! = ArrayList<Int64>(emptySource) @local!
    let emptyQuestion: ArrayList<Int64> @local? = emptyBang
    failed += assertEq(bangEmpty(emptyBang), 3, "T307_bang_empty_repeated_none")
    failed += assertEq(questionEmpty(emptyQuestion), 2, "T307_question_empty_repeated_none")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
