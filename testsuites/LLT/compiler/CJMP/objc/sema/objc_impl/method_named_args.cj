// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

import objc.lang.*

@ObjC
public open foreign class Base {
    public init()
    @ForeignName["primitive1WithArg0:"]
    public open func primitive1(i!: Int64): Int64
    @ForeignName["primitive2WithArg0:withArg1:"]
    public open func primitive2(i!: Int64, f!: Float32): Int64
    @ForeignName["primitive3WithArg0:withArg1:withArg2:"]
    public open func primitive3(i!: Int64, f!: Float32, b!: Bool): Int64
}

@ObjC
public class Derived <: Base {
    public init() {}
    public override func primitive1(i!: Int64): Int64 {
        return i * 2;
    }
    public override func primitive2(i!: Int64, f!: Float32): Int64 {
        return Int64(f) + i + 28;
    }
    public override func primitive3(i!: Int64, f!: Float32, b!: Bool): Int64 {
        return Int64(f) + i + (if (b) { 4 } else { -4 });
    }
}
