// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

func foo(): Unit {
    exclave {
        println(3)
    }
}
exclave func foo(a: String @local?): Unit {
    println(a)
}
main() {}

/* SCAN
error: exclave must be used in function with @local! non copy param or @local!/@local? non copy return type
  ==> sema_exclave_invalid_func_signature.cj:10:5:
   | 
10 |       exclave {
   |  _____^
11 | |         println(3)
12 | |     }
   | |_____^
   | 

error: exclave must be used in function with @local! non copy param or @local!/@local? non copy return type
  ==> sema_exclave_invalid_func_signature.cj:14:1:
   | 
14 | exclave func foo(a: String @local?): Unit {
   | ^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/