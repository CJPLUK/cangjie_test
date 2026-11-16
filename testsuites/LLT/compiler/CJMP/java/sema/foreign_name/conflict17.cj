// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.*

@Java
open foreign class A1 {
    @ForeignName["fooA1"]
    public open func foo(): Unit
}

@Java
foreign interface I1 {
    func foo(): Unit
}

@Java
foreign interface I2 {
    @ForeignName["fooI2"]
    func foo(): Unit
}

@Java
foreign class A2 <: A1 & I1 {
    @ForeignName["fooA2"]
    public func foo(): Unit
}

// ASSERT: scan sema_foreign_name_appeared_in_child
// ASSERT: scan '@ForeignName' cannot be specified on overridden declaration
