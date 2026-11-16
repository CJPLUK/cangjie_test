// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>& 1 | compare %f

@Java
foreign interface I {
    @JavaHasDefault
    static func f(): Int
}

/* SCAN-IN
error: Illegal combination of '@JavaHasDefault' annotation and 'static' modifier
  ==> static_method_in_java_mirror_interface.cj:12:5:
   | 
12 |     static func f(): Int
   |     ^^^^^^^^^^^^^^^^^^^^ 
   |
*/
