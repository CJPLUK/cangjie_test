// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan error: '@ForeignSetterName' cannot be specified on overridden declaration

import objc.lang.*

@ObjC
class A <: M {
    @ForeignSetterName["setA:"]
    override public mut prop a: Int32 {
        get() { 42 }
        set(value) {}
    }
}

@ObjC
public open foreign class M {
    public init()

    @ForeignSetterName["assignA:"]
    public open mut prop a: Int32
}
