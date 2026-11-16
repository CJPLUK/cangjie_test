/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// ERRCHECK: %compiler %local %import-cangjie-stdx %cmp_opt %stdx-package -o %n.%suffix %f
// T405 / S405 / P405: one invalid mode operation.

import stdx.encoding.json.*

main(): Int64 {
    let array: JsonArray @local! = JsonArray() @local!
    let shared: JsonArray @local? = array
    let payload: JsonValue @local! = JsonInt(1) @local!
    shared.add(payload) // Expected rejection: shared receiver cannot mutate.
    0
}

/* SCAN-IN
error: no matching function declaration for function call 'add'
  ==> test_json_local_mode_q_array_add_neg.cj:18:12:
   | 
18 |     shared.add(payload) // Expected rejection: shared receiver cannot mutate.
   |            ^ 
   | 

1 error generated, 1 error printed.
*/
