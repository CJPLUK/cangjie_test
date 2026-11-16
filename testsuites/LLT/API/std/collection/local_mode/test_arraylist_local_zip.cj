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
// T333: zip-only process keeping double-empty/left-empty/right-empty/left-short/
// equal/right-short inputs with exact Int64 x String tuple payload expectations.
// The `other: ArrayList<R> @local!` operand type is the declared signature; the
// rejected @local? operand form is covered by test_arraylist_local_zip_neg_q_other.cj
// and the rejected @local? receiver form by test_arraylist_local_zip_neg_q_receiver.cj.

import std.collection.*
import std.core.*

func verifyZip(left: ArrayList<Int64> @local!, right: ArrayList<String> @local!, expected: Int64): Int64 {
    exclave {
        let zipped: ArrayList<(Int64, String)> @local! = left.zip(right)
        if (zipped.size != expected) { return 1 }
        // Doc-correct payload checks (Int64 exact, String type/value) remain
        // intentionally present even though runtime reaches the barrier first.
        if (expected > 0) {
            let pair: (Int64, String) @local! = zipped[0]
            if (pair[0] != left[0]) { return 1 }
            let stringValue: String @local! = pair[1]
            if (stringValue != right[0]) { return 1 }
        }
        0
    }
}

func makeInt(values: Array<Int64> @local!): ArrayList<Int64> @local! {
    exclave { ArrayList<Int64>(values) @local! }
}

func makeString(values: Array<String> @local!): ArrayList<String> @local! {
    exclave { ArrayList<String>(values) @local! }
}

main(): Int64 {
    var failed = 0
    let emptyI: Array<Int64> @local! = []
    let emptyS: Array<String> @local! = []
    let twoI: Array<Int64> @local! = [1, 2]
    let threeI: Array<Int64> @local! = [1, 2, 3]
    let oneI: Array<Int64> @local! = [1]
    let twoS: Array<String> @local! = ["a", "b"]
    let threeS: Array<String> @local! = ["a", "b", "c"]

    // T333: all six min-size combinations.
    failed += assertEq(verifyZip(makeInt(emptyI), makeString(emptyS), 0), 0, "T333_double_empty")
    failed += assertEq(verifyZip(makeInt(emptyI), makeString(twoS), 0), 0, "T333_left_empty")
    failed += assertEq(verifyZip(makeInt(twoI), makeString(emptyS), 0), 0, "T333_right_empty")
    failed += assertEq(verifyZip(makeInt(oneI), makeString(twoS), 1), 0, "T333_left_short")
    failed += assertEq(verifyZip(makeInt(twoI), makeString(twoS), 2), 0, "T333_equal")
    failed += assertEq(verifyZip(makeInt(threeI), makeString(twoS), 2), 0, "T333_right_short")

    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
