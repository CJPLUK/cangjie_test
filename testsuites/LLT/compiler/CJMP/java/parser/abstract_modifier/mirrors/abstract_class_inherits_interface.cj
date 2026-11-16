// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1

import java.lang.*

@Java
foreign interface I {
    func i(): Unit 
}

@Java
abstract foreign class A <: I {
    public abstract func foo(): Unit
    public abstract func i(): Unit
}

@Java
abstract foreign class Child <: A {
}
