/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package cjworld

import objc.lang.*
import objc.foundation.*

@ObjC
public class A <: M {
    public init() {}
    public open func foo(): S {
        var s = S()
        s.x = 1
        s.y = 1
        s
    }
    public open func s1(p: NSString): NSString {
        println("A.s1 = ${p.toString()}")
        NSString(p.toString() + "_modified")
    }
    public func typeCheck(a: A): Unit {
        println("a is M = ${a is M}")
        let m = (a as M).getOrThrow()
        m.m_foo(114514)
        match (a) {
            case m: M => m.m_foo(666)
            case _ => ()
        }
    }

    @ForeignName["passFunc:str:"]
    public func passFunc(f: CFunc<(Int64, CString, S) -> Unit>, str: NSString): Unit {
        var s = S()
        s.x = 1
        s.y = 2
        unsafe { f(114514, LibC.mallocCString(str.toString()), s) }
    }
}
