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
// String @local? 直接赋给 heap String 槽 —— 非 Copyable 收窄非法，应报 mode 不匹配
// RUN: none (negative case: compilation must fail; SCAN-IN below asserts the diagnostic).
//
// 设计项 LM-DOC-20260910：T206。旁证正例：String(q) heap 拷贝构造合法。
main(): Int64 {
    let heap: String = "H"
    let q: String @local? = heap
    let bad: String = q
    println(bad.size)
    return 0
}

/* SCAN-IN
error: mismatched types
  ==> test_string_local_neg_assign_q_to_heap.cj:18:23:
   | 
18 |     let bad: String = q
   |                       ^ expected 'Struct-String', found 'Struct-String @local?'
   | 
*/
