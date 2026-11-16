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
    let object: JsonObject @local! = JsonObject() @local!
    let shared: JsonObject @local? = object
    let key: String @local! = "key"
    let payload: JsonValue @local! = JsonInt(1) @local!
    shared.put(key, payload) // Expected rejection: shared receiver cannot mutate.
    0
}

/* SCAN-IN
error: no matching function declaration for function call 'put'
  ==> test_json_local_mode_q_object_put_neg.cj:19:12:
   | 
19 |     shared.put(key, payload) // Expected rejection: shared receiver cannot mutate.
   |            ^ 
   | 

1 error generated, 1 error printed.
*/
