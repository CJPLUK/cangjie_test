// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -o %output %cmp_opt 2>&1 | compare %f

class C {
    static func foo(this @local!) {}

    static init(this @local!) {}
}
main() {}

/* SCAN
error: unexpected this param on non member function or static function
  ==> static_func_bad.cj:10:21:
   | 
10 |     static func foo(this @local!) {}
   |                     ^^^^^^^^^^^^ 
   | 

error: unexpected this param on non member function or static function
  ==> static_func_bad.cj:12:17:
   | 
12 |     static init(this @local!) {}
   |                 ^^^^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
