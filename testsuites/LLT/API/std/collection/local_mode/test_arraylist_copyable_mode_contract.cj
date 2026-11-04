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
// LM-DOC-20260910: T312-T319 mode contract read-side probes only.  Mutating
// behavior belongs to test_arraylist_local_set.cj and
// test_arraylist_copyable_extension.cj (both disabled on RT-1/C3).

import std.collection.*
import std.core.*

func bangRead(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.size + a.capacity + a[0]
    }
}

func questionRead(a: ArrayList<Int64> @local?): Int64 {
    a.size + a.capacity + a[0]
}

func bangEmpty(a: ArrayList<Int64> @local!): Bool {
    exclave { a.isEmpty() }
}

func questionEmpty(a: ArrayList<Int64> @local?): Bool {
    a.isEmpty()
}

func bangStringRead(a: ArrayList<String> @local!): Int64 {
    exclave { a.size + a.capacity }
}

func questionStringRead(a: ArrayList<String> @local?): Int64 {
    a.size + a.capacity
}

main(): Int64 {
    var failed = 0
    let source: Array<Int64> @local! = [7, 8]
    let bang: ArrayList<Int64> @local! = ArrayList<Int64>(source) @local!
    let question: ArrayList<Int64> @local? = bang
    failed += assertEq(bangRead(bang), 11, "T312_bang_read_mode")
    failed += assertEq(questionRead(question), 11, "T312_question_read_mode")
    failed += assertB(!bangEmpty(bang), "T316_bang_nonempty")
    failed += assertB(!questionEmpty(question), "T316_question_nonempty")

    let emptySource: Array<Int64> @local! = []
    let emptyBang: ArrayList<Int64> @local! = ArrayList<Int64>(emptySource) @local!
    let emptyQuestion: ArrayList<Int64> @local? = emptyBang
    failed += assertB(bangEmpty(emptyBang), "T316_bang_empty")
    failed += assertB(questionEmpty(emptyQuestion), "T316_question_empty")

    // String proves the non-Copyable mode slot without touching corrupted
    // reference payloads; the concrete mutator is intentionally not called.
    let strings: Array<String> @local! = ["before"]
    let stringBang: ArrayList<String> @local! = ArrayList<String>(strings) @local!
    let stringQuestion: ArrayList<String> @local? = stringBang
    failed += assertEq(bangStringRead(stringBang), 2, "T312_bang_string_mode")
    failed += assertEq(questionStringRead(stringQuestion), 2, "T312_question_string_mode")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
