/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// ERRCHECK: %compiler %local %import-cangjie-stdx %cmp_opt %stdx-package -o %n.%suffix %f
//
// LM-DOC-20260910 LEGIT-NEG (T532): one illegal heap-to-local assignment only.
// The heap serializer line is a valid mode control and must not be used to hide
// a second error.  Diagnostic wording/location is not an oracle; the expected
// failure is a mode mismatch at the assignment below.
//
// The case is written as ERRCHECK + SCAN so the harness actually compiles it and
// asserts the compiler diagnostic, rather than being skipped via DISABLED-EXEC.

import stdx.encoding.json.*

main(): Int64 {
    let heapValue: JsonValue = JsonValue.fromStr("[1,2]")
    let heapArray: JsonArray = heapValue.asArray()
    let _: String = heapArray.toString()
    let localArray: JsonArray @local! = heapArray
    return 0
}

/* SCAN
error: mismatched types
  ==> test_json_local_mode_neg_01.cj:24:41:
   | 
24 |     let localArray: JsonArray @local! = heapArray
   |                                         ^^^^^^^^^ expected 'Class-JsonArray @local!', found 'Class-JsonArray'
   | 

1 error generated, 1 error printed.
*/
