// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>& 1 | compare %f

@JavaHasDefault
func f() {}

@Java
foreign class C {
    public func foo(): Unit
}

/* SCAN-IN
error: '@JavaHasDefault' can only be used on member functions in '@Java' foreign interface
 ==> top_level_func.cj:9:1:
  | 
9 | @JavaHasDefault
  | ^^^^^^^^^^^^^^^ 
  |  
*/
