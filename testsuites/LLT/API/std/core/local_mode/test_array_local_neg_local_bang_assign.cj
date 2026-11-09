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
// T129 heap Array<Int64> cannot be assigned directly to Array<Int64> @local! slot
// RUN: none (negative case: compilation must fail; SCAN-IN below asserts the diagnostic).
//
// This is a single intentional T129 mode negative. A heap value cannot be silently
// reclassified as a local! value; callers must use a local-mode constructor/copy path.

main(): Int64 {
    let heap: Array<Int64> = [1, 2]
    let localBang: Array<Int64> @local! = heap
    0
}

/* SCAN-IN
error: mismatched types
  ==> test_array_local_neg_local_bang_assign.cj:19:43:
   | 
19 |     let localBang: Array<Int64> @local! = heap
   |                                           ^^^^ expected 'Struct-Array<Int64> @local!', found 'Struct-Array<Int64>'
   | 
*/
