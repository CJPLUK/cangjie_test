// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

let a = exclave {
    42
}

func foo(a!: Int64 = exclave { 33 }) {
    a
}

main() {}

/* SCAN
error: exclave must be used in a function
  ==> sema_exclave_outside_function.cj:9:9:
   | 
9  |   let a = exclave {
   |  _________^
10 | |     42
11 | | }
   | |_^
   | 

error: exclave must be used in a function
  ==> sema_exclave_outside_function.cj:13:22:
   | 
13 | func foo(a!: Int64 = exclave { 33 }) {
   |                      ^^^^^^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
