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
    let fp: ObjCBlock<(Float64) -> Float64>
    mut prop fProp: ObjCBlock<(Float64) -> Float64> {
        get() { M().fPtr() }
        set(x) {}
    }

    public init() {
        super()
        fp = M().fPtr()
    }
    @ForeignName["mapF:"]
    public func mapF(f: ObjCBlock<(Float64) -> Float64>): Float64 {
        return f.call(3.14)
    }
    @ForeignName["returnF:"]
    public func returnF(f: ObjCBlock<(Float64) -> Float64>): ObjCBlock<(Float64) -> Float64> {
        return f
    }
}

@ObjC
public foreign class N {
    public init()
    @ForeignName["mapF:"]
    public func mapF(f: ObjCBlock<(Float64) -> Float64>): Float64
    @ForeignName["letF:"]
    public func letF(f: ObjCBlock<(N) -> N>): N
    public func id(): Int64
}

@ObjC
public open foreign class M {
    public init()
    public func fPtr(): ObjCBlock<(Float64) -> Float64>
    public func iPtr(): ObjCBlock<(Float64) -> Float64>
    public func makeK(): K
    public func makeNFunc(): ObjCBlock<(N) -> N>
}
