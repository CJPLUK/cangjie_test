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
// T206: heap(String @~local) assigned to a String @local! slot must be
// rejected as a mode mismatch at the assignment (compile-time).
//
// 设计项 LM-DOC-20260910：T206（S204 四个直接非法赋值之一）。旁证正例：
// String(q) 显式拷贝构造合法（见 test_string_local_construct.cj T204）。
main(): Int64 {
    let heap: String = "H"
    let bad: String @local! = heap
    println(bad.size)
    return 0
}

/* SCAN-IN
error: mismatched types
  ==> test_string_local_neg_assign_heap_to_local.cj:18:31:
   | 
18 |     let bad: String @local! = heap
   |                               ^^^^ expected 'Struct-String @local!', found 'Struct-String'
   | 
*/
