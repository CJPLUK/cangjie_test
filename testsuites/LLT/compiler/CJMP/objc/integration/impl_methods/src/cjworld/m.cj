// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

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
    public open func arg0(): Bool
    @ForeignName["primitive1WithArg0:"]
    public open func primitive1(i: Int64): Int64
    @ForeignName["primitive2WithArg0:withArg1:"]
    public open func primitive2(i: Int64, f: Float32): Int64
    @ForeignName["primitive3WithArg0:withArg1:withArg2:"]
    public open func primitive3(i: Int64, f: Float32, b: Bool): Int64

    @ForeignName["mirror1WithArg0:"]
    public open func mirror1(arg0: Box): Int64
    @ForeignName["mirror2WithArg0:withArg1:"]
    public open func mirror2(arg0: Box, arg1: Box): Int64
    @ForeignName["mirror3WithArg0:withArg1:withArg2:"]
    public open func mirror3(arg0: Box, arg1: Box, arg2: Box): Int64

    @ForeignName["impl1WithArg0:"]
    public open func impl1(arg0: ImplBox): Int64
    @ForeignName["impl2WithArg0:withArg1:"]
    public open func impl2(arg0: ImplBox, arg1: ImplBox): Int64
    @ForeignName["impl3WithArg0:withArg1:withArg2:"]
    public open func impl3(arg0: ImplBox, arg1: ImplBox, arg2: ImplBox): Int64
    @ForeignName["returnMirror:"]
    public open func returnMirror(box: Box): Box
    @ForeignName["returnImpl:"]
    public open func returnImpl(box: ImplBox): ImplBox

}

@ObjC
public class Derived <: Base {
    public init() {}
    public override func arg0(): Bool {
        false
    }
    public override func primitive1(i: Int64): Int64 {
        return i * 2;
    }
    public override func primitive2(i: Int64, f: Float32): Int64 {
        return Int64(f) + i + 28;
    }
    public override func primitive3(i: Int64, f: Float32, b: Bool): Int64 {
        return Int64(f) + i + (if (b) { 4 } else { -4 });
    }

    public override func mirror1(arg0: Box): Int64 {
        return -arg0.value
    }
    public override func mirror2(arg0: Box, arg1: Box): Int64 {
        return -(arg0.value + arg1.value)
    }
    public override func mirror3(arg0: Box, arg1: Box, arg2: Box): Int64 {
        return -(arg0.value + arg1.value + arg2.value)
    }

    public override func impl1(arg0: ImplBox): Int64 {
        return -arg0.value
    }
    public override func impl2(arg0: ImplBox, arg1: ImplBox): Int64 {
        return -(arg0.value + arg1.value)
    }
    public override func impl3(arg0: ImplBox, arg1: ImplBox, arg2: ImplBox): Int64 {
        return -(arg0.value + arg1.value + arg2.value)
    }

    @ForeignName["static1WithArg:"]
    public static func static1(arg0: Box): Int64 {
        return -arg0.value
    }
    @ForeignName["static2WithArg0:withArg1:"]
    public static func static2(arg0: Box, arg1: Box): Int64 {
        return -(arg0.value + arg1.value)
    }
    @ForeignName["static3WithArg0:withArg1:withArg2:"]
    public static func static3(arg0: Box, arg1: Box, arg2: Box): Int64 {
        return -(arg0.value + arg1.value + arg2.value)
    }

    public open func returnMirror(box: Box): Box {
        return box;
    }
    public open func returnImpl(box: ImplBox): ImplBox {
        return box;
    }
}

@ObjC
public foreign class Factory {
    public init()
    public func derived(): Derived
    public func base(): Base
    public func derivedAsBase(): Base
    @ForeignName["boxWith:"]
    public func boxWith(value: Int64): ImplBox
}
