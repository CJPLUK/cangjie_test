// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.JObject

@Java
foreign class M1 {
    @ForeignName["fooJava"]
    public open func foo(): Unit
}

@Java
foreign interface I {
    @ForeignName["fooJava"]
    public open func foo(): Unit
}

@Java
abstract foreign class A {
    @ForeignName["fooJava"]
    public open func foo(): Unit
}

@Java
foreign interface I1 {
    @ForeignName["bar"]
    func foo(): Unit 
}

@Java
foreign interface I2 {
    @ForeignName["bar"]
    func foo(): Unit 
}

@Java
open foreign class M2 {
    @ForeignName["bar"]
    public open func foo(): Unit
}

@Java
open foreign class M3 <: M2 & I1 & I2 {
}

@Java
open foreign class M4 <: M2 & I1 & I2 {
    public open override func foo(): Unit
}

// ASSERT: scan-not error
