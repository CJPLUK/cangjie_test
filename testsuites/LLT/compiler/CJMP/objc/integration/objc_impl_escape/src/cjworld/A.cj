// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package cjworld

import std.runtime.*
import objc.lang.*

@ObjC
public class A <: M {
    private var visits = 0

    public init() {
        println("cj: A()")
    }

    public func visit(): Unit {
        visits++
    }

    public func visitCount(): Int64 {
        visits
    }

    public override func description(): ?NSString {
        NSString("A(visits=${visits})")
    }

    @ForeignName["createObject"]
    public static func createObject(): M {
        println("cj: createObject()")
        let a = A()
        a.visit()
        a
    }

    @ForeignName["collectGarbage"]
    public static func collectGarbage(): Unit {
        println("cj: collectGarbage()")
        gc()
    }

    /// Takes the escaped object back from Objective-C and checks it is the very same Cangjie instance.
    @ForeignName["acceptObject:"]
    public static func acceptObject(obj: M): Unit {
        println("cj: acceptObject(${obj.toString()})")

        if (let Some(a) <- (obj as A)) {
            println("cj: downcast to A succeeded, visits=${a.visitCount()}")
            a.visit()
            println("cj: after visit, visits=${a.visitCount()}")
        } else {
            println("cj: downcast to A failed")
        }
    }
}
