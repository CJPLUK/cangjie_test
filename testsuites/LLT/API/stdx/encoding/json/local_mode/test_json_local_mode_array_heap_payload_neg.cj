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
    let payload: JsonValue = JsonInt(1)
    array.add(payload) // Expected rejection: payload is heap mode.
    0
}

/* SCAN-IN
error: mismatched types
  ==> test_json_local_mode_array_heap_payload_neg.cj:17:15:
   | 
17 |     array.add(payload) // Expected rejection: payload is heap mode.
   |               ^^^^^^^ expected 'Class-JsonValue @local!', found 'Class-JsonValue'
   | 

1 error generated, 1 error printed.
*/
