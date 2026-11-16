// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

/*
SCAN-IN
error: function 'f' can not be abstract
  ==> mirror_abstract_static_method.cj:25:5:
   | 
25 |     public abstract static func f(): Int32
   |     ^ 
   |
*/


import java.lang.JObject

@Java
abstract foreign class A {
    public init()
    public abstract static func f(): Int32
}
