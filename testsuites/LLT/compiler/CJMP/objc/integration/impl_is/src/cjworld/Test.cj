// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class Test <: Base {
    public Test() {
    }

    @ForeignName["base2IsProto:"]
    public func base2IsProto(m: Base2): Unit {
        var test = m is BaseProto; println("Base2 is BaseProto: ${test}")
    }

    @ForeignName["baseIsProto:"]
    public func base2IsProto(m: Base): Unit {
        var test = m is BaseProto; println("Base is BaseProto: ${test}")
    }

    @ForeignName["KIsProto:"]
    public func KIsProto(m: Base2): Unit {
        var test = m is BaseProto; println("K is BaseProto: ${test}")
    }

    @ForeignName["baseIsBase:"]
    public func baseIsBase(m: Base): Unit {
        var test = m is Base; println("Base is Base: ${test}")
    }

    @ForeignName["baseIsA1:"]
    public func baseIsA1(m: Base): Unit {
        var test = m is A1; println("Base is A1: ${test}")
    }

    @ForeignName["baseIsA2:"]
    public func baseIsA2(m: Base): Unit {
        var test = m is A2; println("Base is A2: ${test}")
    }

    @ForeignName["A1isBase:"]
    public func A1isBase(m: Base): Unit {
        var test = m is Base; println("A1 is Base: ${test}")
    }

    @ForeignName["A2isBase:"]
    public func A2isBase(m: Base): Unit {
        var test = m is Base; println("A2 is Base: ${test}")
    }

    @ForeignName["A1isA2:"]
    public func A1isA2(m: Base): Unit {
        var test = m is A2; println("A1 is A2: ${test}")
    }

    @ForeignName["A1isA1:"]
    public func A1isA1(m: Base): Unit {
        var test = m is A1; println("A1 is A1: ${test}")
    }

    @ForeignName["A2isA2:"]
    public func A2isA2(m: Base): Unit {
        var test = m is A2; println("A2 is A2: ${test}")
    }

    @ForeignName["BisA1"]
    public func BisA1(): Unit {
        let b = B()
        var test = b is A1; println("B is A1: ${test}")
    }
}
