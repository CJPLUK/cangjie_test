// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f


import java.lang.JObject

@Java
abstract foreign class A {
    init()
    public abstract func f(): Unit
}

@Java
class Impl <: A {
    init() {
        super.f()
    }

    public func f() {}
}

/* SCAN-IN
error: abstract method 'f' cannot be accessed directly
  ==> java_mirror_abstract_func_call_in_subtype_constructor.cj:15:9:
   | 
15 |         super.f()
   |         ^ 
   |
*/
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
