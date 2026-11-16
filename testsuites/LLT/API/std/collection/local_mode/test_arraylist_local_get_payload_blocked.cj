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
// T305: ArrayList.get/first/last Some payloads asserted exactly (Int64) with
// String retaining its mode/type slots.
// UPDATE 2026-09-29: runs ALL PASSED on the 2026-09-28 SDK; the earlier
// `Barrier::WriteGeneric does not support local object` abort record is obsolete.

import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0
    let ints: Array<Int64> @local! = [1, 2, 3]
    let bang: ArrayList<Int64> @local! = ArrayList<Int64>(ints) @local!
    let question: ArrayList<Int64> @local? = bang
    let b0: Option<Int64> @local! = bang.get(0)
    let q2: Option<Int64> @local? = question.get(2)
    match (b0) {
        case Some(v) => failed += assertEq(v, 1, "T305_bang_get_some_payload")
        case None => failed += 1
        println("FAIL: T305_bang_get_some_payload — expected Some(1)")
    }
    match (q2) {
        case Some(v) => failed += assertEq(v, 3, "T305_question_get_some_payload")
        case None => failed += 1
        println("FAIL: T305_question_get_some_payload — expected Some(3)")
    }
    let bf: Option<Int64> @local! = bang.first
    let ql: Option<Int64> @local? = question.last
    match (bf) {
        case Some(v) => failed += assertEq(v, 1, "T305_bang_first_payload")
        case None => failed += 1
        println("FAIL: T305_bang_first_payload — expected Some(1)")
    }
    match (ql) {
        case Some(v) => failed += assertEq(v, 3, "T305_question_last_payload")
        case None => failed += 1
        println("FAIL: T305_question_last_payload — expected Some(3)")
    }

    let strings: Array<String> @local! = ["a", "b"]
    let stringBang: ArrayList<String> @local! = ArrayList<String>(strings) @local!
    let stringQuestion: ArrayList<String> @local? = stringBang
    let sb: Option<String> @local! = stringBang.get(0)
    let sq: Option<String> @local? = stringQuestion.get(1)
    let sfirst: Option<String> @local! = stringBang.first
    let slast: Option<String> @local? = stringQuestion.last
    let sbIndex: String @local! = stringBang[0]
    let sqIndex: String @local? = stringQuestion[1]
    var slots: Int64 = 0
    match (sb) {
        case Some(_) => slots++
        case None => ()
    }
    match (sq) {
        case Some(_) => slots++
        case None => ()
    }
    match (sfirst) {
        case Some(_) => slots++
        case None => ()
    }
    match (slast) {
        case Some(_) => slots++
        case None => ()
    }
    failed += assertEq(slots, 4, "T305_string_option_mode_slots")
    failed += assertEq(sbIndex.size + sqIndex.size, 2, "T305_string_index_mode_slots")

    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
