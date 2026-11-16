// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class NSObject {
    public init()
}

@ObjC
public class K <: NSObject {
    public init() {
        super()
    }
    @ForeignName["fPtr:"]
    public func fPtr(value: ObjCPointer<Float64>): ObjCPointer<Float64> {
        return value;
    }
}

@ObjC
public foreign class N {
    public init()
    @ForeignName["fPtr:"]
    public func fPtr(value: ObjCPointer<Float64>): ObjCPointer<Float64>
}

@ObjC
public open foreign class M {
    public init()
    @ForeignName["fPtr:"]
    public func fPtr(value: ObjCPointer<Float64>): ObjCPointer<Float64>
    @ForeignName["iPtr:"]
    public func iPtr(value: ObjCPointer<Int64>): ObjCPointer<Int64>
    @ForeignName["pPtr:"]
    public func pPtr(value: ObjCPointer<ObjCPointer<Int64>>): ObjCPointer<ObjCPointer<Int64>>
    @ForeignName["sPtr:"]
    public func sPtr(value: ObjCPointer<N>): ObjCPointer<N>
    @ForeignName["ssPtr:"]
    public func ssPtr(value: ObjCPointer<K>): ObjCPointer<K>
}
