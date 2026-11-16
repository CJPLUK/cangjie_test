// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class Test <: Base {
    public Test() {}

    @ForeignName["matchTest:"]
    public func matchTest(m: Base): Unit {
        match (m) {
            case x: A
                where x.i == 5 ||
                      x.i == 0
                                => x.test()
            case _: A           => println("A, where i not 5 or 0")
            case _: B           => println("B")
            case x: BaseProto   => x.identify()
            case _: ObjCId      => println("ObjCId")
            case _              => println("_")
        }
    }

    @ForeignName["nestedMatch:"]
    public func nestedMatch(m: Base): Unit {
        match (m) {
            case mm: A => match (mm) {
                case mmm: D => println("m is D")
                case _      => println("m is A but not D")
            }
            case _ => println("m is not A")
        }
    }
}
