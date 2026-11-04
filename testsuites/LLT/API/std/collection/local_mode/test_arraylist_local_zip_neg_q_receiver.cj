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
// T332: zip is declared only as `zip<R>(this @local!, other: ArrayList<R> @local!)`.
// CJEEP-005 removed the ListOfCopyable receiver surface, so a @local? receiver has
// no zip overload to select and the call must be rejected at compile time.
import std.collection.*
import std.core.*

func rejectHalfReferenceReceiver(): Int64 {
    let leftSource: Array<Int64> @local! = [1]
    let rightSource: Array<String> @local! = ["a"]
    let left: ArrayList<Int64> @local? = ArrayList<Int64>(leftSource) @local!
    let right: ArrayList<String> @local! = ArrayList<String>(rightSource) @local!
    let invalid: ArrayList<(Int64, String)> @local! = left.zip(right)
    invalid.size
}

main(): Int64 {
    0
}

/* SCAN-IN
error: no matching function declaration for function call 'zip'
  ==> test_arraylist_local_zip_neg_q_receiver.cj:22:60:
   | 
22 |     let invalid: ArrayList<(Int64, String)> @local! = left.zip(right)
   |                                                            ^ 
   | 
*/
