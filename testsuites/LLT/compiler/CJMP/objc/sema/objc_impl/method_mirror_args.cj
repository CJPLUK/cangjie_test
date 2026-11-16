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
public open foreign class Base {
    public init()
    @ForeignName["mirror1WithArg0:"]
    public open func mirror1(arg0: Box): Int64
    @ForeignName["mirror2WithArg0:withArg1:"]
    public open func mirror2(arg0: Box, arg1: Box): Int64
    @ForeignName["mirror3WithArg0:withArg1:withArg2:"]
    public open func mirror3(arg0: Box, arg1: Box, arg2: Box): Int64
    @ForeignName["returnMirror:"]
    public open func returnMirror(box: Box): Box
}

@ObjC
public class Derived <: Base {
    public init() {}
    public override func mirror1(arg0: Box): Int64 {
        return -arg0.value
    }
    public override func mirror2(arg0: Box, arg1: Box): Int64 {
        return -(arg0.value + arg1.value)
    }
    public override func mirror3(arg0: Box, arg1: Box, arg2: Box): Int64 {
        return -(arg0.value + arg1.value + arg2.value)
    }
    public open func returnMirror(box: Box): Box {
        return box;
    }
}
