/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// ERRCHECK: %compiler %local %import-cangjie-stdx %cmp_opt %stdx-package -o %n.%suffix %f
//
// LM-DOC-20260910 LEGIT-NEG fragment (T533): pass a local JsonArray to a
// function whose parameter is the heap receiver type.  This is deliberately the
// only invalid operation in this file.
//
// Verified 2026-09-21 with the rebuilt stdx: the local overloads exist, so cjc
// reaches the intended call and reports a mode mismatch at acceptHeapArray.
// The remaining T533 fragments (Q-array add, Q-object put, L-container write of
// heap payload) require independent source files; they are not combined here.
//
// The case is written as ERRCHECK + SCAN so the harness actually compiles it and
// asserts the compiler diagnostic, rather than being skipped via DISABLED-EXEC.

import stdx.encoding.json.*

func acceptHeapArray(array: JsonArray): Int64 {
    array.size()
}

main(): Int64 {
    let source: String @local! = "[1]"
    let value: JsonValue @local! = JsonValue.fromStr(source)
    let localArray: JsonArray @local! = value.asArray()
    acceptHeapArray(localArray)
    return 0
}

/* SCAN
error: mismatched types
  ==> test_json_local_mode_neg_02.cj:32:21:
   | 
32 |     acceptHeapArray(localArray)
   |                     ^^^^^^^^^^ expected 'Class-JsonArray', found 'Class-JsonArray @local!'
   | 

1 error generated, 1 error printed.
*/
