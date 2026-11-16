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
// (T410): passing String @local! result to heapOnly(String) must report a mode mismatch at the escape
// RUN: none (negative case: compilation must fail; SCAN-IN below asserts the diagnostic).

import std.core.*

func heapOnly(value: String): Unit {
    let _ = value
}

func triggerFullEscape(): Unit {
    let localText: String @local! = "local"
    let receiver: ToString @local? = localText
    let fullResult: String @local! = receiver.toString()
    heapOnly(fullResult)
}

main(): Int64 {
    triggerFullEscape()
    0
}

/* SCAN-IN
error: mismatched types
  ==> test_interface_full_result_escape_neg.cj:24:14:
   | 
24 |     heapOnly(fullResult)
   |              ^^^^^^^^^^ expected 'Struct-String', found 'Struct-String @local!'
   | 
*/
