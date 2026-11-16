// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

let gGlobal: Int = exclave { 10 }

class C {
    static var s: Int = exclave { 20 }
}

main(): Int {
    0
}

/* SCAN
error: exclave must be used in a function
 ==> exclave_in_global_var.cj:9:20:
  | 
9 | let gGlobal: Int = exclave { 10 }
  |                    ^^^^^^^^^^^^^^ 
  | 

error: exclave must be used in a function
  ==> exclave_in_global_var.cj:12:25:
   | 
12 |     static var s: Int = exclave { 20 }
   |                         ^^^^^^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
