// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import objc.lang.*

@ObjC
public foreign class N {
    init()

    @ForeignName["zeroParams"]
    public func zeroParams(): A

    @ForeignName["oneParam:"]
    public func oneParam(first: ObjCPointer<Int64>): M

    @ForeignName["twoParams:second:"]
    public func twoParams(first: M, second: Float64): A

    @ForeignName["fiveParams:second:third:fourth:fifth:"]
    public func fiveParams(first: ObjCPointer<A>, second: IntNative, third: Float64, fourth: A, fifth: ObjCPointer<Byte>): M
}

@ObjC
public class A <: M {
    init() {
        super()
    }
}

@ObjC
public open foreign class M {
    init()
}
