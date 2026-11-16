/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// ERRCHECK: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// T332: zip requires `other: ArrayList<R> @local!`. The 2026-09-18 correction to the
// closure document records that a @local? operand cannot build the `(T, R) @local!`
// tuple, so the argument must be @local! and a @local? argument is rejected at
// compile time. The @local!/@local! form is covered by test_arraylist_local_zip.cj.
//
// The diagnostics are asserted with `regex` instead of a `SCAN-IN` block. A SCAN-IN
// block is a literal substring, so it pinned the line number of the declaration the
// note points at, and every edit to that file moved it. These patterns keep the
// meaning of each diagnostic without depending on where the declaration sits.
import std.collection.*
import std.core.*

func rejectHalfReferenceOperand(): Int64 {
    let leftSource: Array<Int64> @local! = [1]
    let rightSource: Array<String> @local! = ["a"]
    let left: ArrayList<Int64> @local! = ArrayList<Int64>(leftSource) @local!
    let rightBang: ArrayList<String> @local! = ArrayList<String>(rightSource) @local!
    let rightQ: ArrayList<String> @local? = rightBang
    let invalid: ArrayList<(Int64, String)> @local! = left.zip(rightQ)
    invalid.size
}

main(): Int64 {
    0
}

// ASSERT: regex error: unable to infer generic argument of this function
// ASSERT: regex note: for function type '\(Class-ArrayList<Generics-R> @local!\) -> Class-ArrayList<Tuple<Generics-T, Generics-R>> @local!' in context type 'Class-ArrayList<Int64> @local!'
// ASSERT: regex note: mismatched types
// ASSERT: regex of type 'Class-ArrayList<Struct-String>', impossible to match parameter type 'Class-ArrayList<Generics-R>'
// ASSERT: regex 1 error generated, 1 error printed\.
