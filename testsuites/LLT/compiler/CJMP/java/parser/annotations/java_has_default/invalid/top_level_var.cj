// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>& 1 | compare %f

@JavaHasDefault
let a = 1

@JavaHasDefault
var b = ""

@Java
foreign class C {
    public func foo(): Unit
}

/* SCAN-IN
error: unexpected annotation '@JavaHasDefault' on let
  ==> top_level_var.cj:9:1:
   | 
9  | @JavaHasDefault
   | ^^^^^^^^^^^^^^^ unexpected annotation here
10 | let a = 1
   | ~~~ on let
*/

/* SCAN-IN
error: unexpected annotation '@JavaHasDefault' on var
  ==> top_level_var.cj:12:1:
   | 
12 | @JavaHasDefault
   | ^^^^^^^^^^^^^^^ unexpected annotation here
13 | var b = ""
   | ~~~ on var
*/

/* SCAN-IN
2 errors generated, 2 errors printed.
*/
