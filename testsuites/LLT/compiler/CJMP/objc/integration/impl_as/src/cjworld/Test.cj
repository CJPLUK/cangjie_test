// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class Test <: Base {
    public let letA: A

    public Test() {
        letA = A()
    }

    @ForeignName["baseAsA:"]
    public func baseAsA(m: Base): Unit {
        let a = m as A
        match(a) {
            case Some(x)    => println("m as A: Some"); x.test()
            case None       => println("m as A: None")
        }
    }

    @ForeignName["baseAsB:"]
    public func baseAsB(m: Base): Unit {
        let a = m as B
        match(a) {
            case Some(_)    => println("m as B: Some")
            case None       => println("m as B: None")
        }
    }

    @ForeignName["baseAsProto:"]
    public func baseAsProto(m: Base): Unit {
        let a = m as BaseProto
        match(a) {
            case Some(x)    => println("m as Proto: Some"); x.identify()
            case None       => println("m as Proto: None")
        }
    }

    @ForeignName["baseAsProto2:"]
    public func baseAsProto2(m: Base): Unit {
        let a = m as BaseProto2
        match(a) {
            case Some(x)    => println("m as Proto2: Some")
            case None       => println("m as Proto2: None")
        }
    }

    @ForeignName["CasA"]
    public func cAsA(): Unit {
        let c = C()
        let a = c as A
        match(a) {
            case Some(_)    => println("c as A: Some")
            case None       => println("c as A: None")
        }
    }
}
