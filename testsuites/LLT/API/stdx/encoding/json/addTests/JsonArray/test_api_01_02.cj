/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// ERRCHECK: %compiler  %import-cangjie-stdx  %cmp_opt %stdx-package  -o %n.%suffix %f

import stdx.encoding.json.*

main(): Int64 {
    var initFunc = JsonArray()
    // Reject an Array argument to add.
    var result = initFunc.add([1, 2, 3])
    return 0
}

/* SCAN
error: mismatched types
  ==> test_api_01_02.cj:15:31:
   | 
15 |     var result = initFunc.add([1, 2, 3])
   |                               ^^^^^^^^^ expected 'Class-JsonValue', found 'Array'
   | 

1 error generated, 1 error printed.
*/
