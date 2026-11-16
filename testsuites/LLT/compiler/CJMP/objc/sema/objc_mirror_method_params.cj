// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import objc.lang.*

type PrimitiveType = Int8

@ObjC
public foreign class M {
    init()

    @ForeignName["zeroParams"]
    public func zeroParams(): Unit

    @ForeignName["oneParam:"]
    public func oneParam(first: ObjCPointer<Int64>): Unit

    @ForeignName["twoParams:second:"]
    public func twoParams(first: Int64, second: Float64): Unit

    @ForeignName["fiveParams:second:third:fourth:fifth:"]
    public func fiveParams(first: ObjCPointer<Int64>, second: IntNative, third: PrimitiveType, fourth: Bool, fifth: ObjCPointer<Byte>): Unit
}
