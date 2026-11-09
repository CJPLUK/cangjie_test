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
// LM-DOC-20260910: T305/T306.  Int64 Option payloads are asserted exactly;
// String payloads are used only as non-Copyable mode/type slots because the
// current SDK still corrupts local Option reference payloads (C7).

import std.collection.*
import std.core.*


func bangIsNone(a: ArrayList<Int64> @local!, index: Int64): Bool {
    exclave {
        let value: Option<Int64> @local! = a.get(index)
        match (value) {
            case Some(_) => false
            case None => true
        }
    }
}

func qIsNone(a: ArrayList<Int64> @local?, index: Int64): Bool {
    let value: Option<Int64> @local? = a.get(index)
    match (value) {
        case Some(_) => false
        case None => true
    }
}

func bangIndex(a: ArrayList<Int64> @local!, index: Int64): Int64 {
    exclave { a[index] }
}

func qIndex(a: ArrayList<Int64> @local?, index: Int64): Int64 {
    a[index]
}

func bangFirst(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let value: Option<Int64> @local! = a.first
        match (value) {
            case Some(v) => v
            case None => -1
        }
    }
}



func qLast(a: ArrayList<Int64> @local?): Int64 {
    let value: Option<Int64> @local? = a.last
    match (value) {
        case Some(v) => v
        case None => -1
    }
}


main(): Int64 {
    var failed = 0
    let source: Array<Int64> @local! = [1, 2, 3, 4, 5]
    let bang: ArrayList<Int64> @local! = ArrayList<Int64>(source) @local!
    let question: ArrayList<Int64> @local? = bang

    // T305: get out-of-range/empty first-last are None; direct [] payload
    // reads are exact.  Some payload paths are preserved in the C7 blocked
    // probe because ArrayList.get currently trips the local write barrier.
    failed += assertB(bangIsNone(bang, -1), "T305_bang_get_negative_none")
    failed += assertB(qIsNone(question, 5), "T305_question_get_size_none")
    failed += assertEq(bangIndex(bang, 1), 2, "T305_bang_index1")
    failed += assertEq(qIndex(question, 3), 4, "T305_question_index3")
    let emptySource: Array<Int64> @local! = []
    let emptyBang: ArrayList<Int64> @local! = ArrayList<Int64>(emptySource) @local!
    let emptyQuestion: ArrayList<Int64> @local? = emptyBang
    failed += assertB(bangIsNone(emptyBang, 0), "T305_empty_get_none")
    failed += assertEq(bangFirst(emptyBang), -1, "T305_empty_first_none")
    failed += assertEq(qLast(emptyQuestion), -1, "T305_empty_last_none")
    try {
        let _ = bangIndex(bang, -1)
        failed += 1
        println("FAIL: T305_bang_index_negative — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        let _ = qIndex(question, 5)
        failed += 1
        println("FAIL: T305_question_index_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    // String mode/type slots (without payload reads) are preserved in the
    // blocked C7 probe test_arraylist_local_get_payload_blocked.cj.
    // T306 slice/[](Range) doc-correct matrix is retained in
    // test_arraylist_local_get_slice_blocked.cj.  The 0907 SDK frontend
    // accepts these calls but links no local ArrayList slice/range symbols.


    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
