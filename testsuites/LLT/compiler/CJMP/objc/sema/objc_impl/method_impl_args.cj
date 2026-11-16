// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

import objc.lang.*

@ObjC
public open foreign class Box {
    public init()
    public open mut prop value: Int64
}

@ObjC
public class ImplBox <: Box {
    public init() {}
    private var _value: Int64 = 0;
    public mut prop value: Int64  {
        get() {
            _value;
        }
        set(v) {
            _value = v % 5;
        }
    }
}

@ObjC
public open foreign class Base {
    public init()
    @ForeignName["impl1WithArg0:"]
    public open func impl1(arg0: ImplBox): Int64
    @ForeignName["impl2WithArg0:withArg1:"]
    public open func impl2(arg0: ImplBox, arg1: ImplBox): Int64
    @ForeignName["impl3WithArg0:withArg1:withArg2:"]
    public open func impl3(arg0: ImplBox, arg1: ImplBox, arg2: ImplBox): Int64
    @ForeignName["returnImpl:"]
    public open func returnImpl(box: ImplBox): ImplBox
}

@ObjC
public class Derived <: Base {
    public init() {}

    public override func impl1(arg0: ImplBox): Int64 {
        return -arg0.value
    }
    public override func impl2(arg0: ImplBox, arg1: ImplBox): Int64 {
        return -(arg0.value + arg1.value)
    }
    public override func impl3(arg0: ImplBox, arg1: ImplBox, arg2: ImplBox): Int64 {
        return -(arg0.value + arg1.value + arg2.value)
    }
    public open func returnImpl(box: ImplBox): ImplBox {
        return box;
    }
}
