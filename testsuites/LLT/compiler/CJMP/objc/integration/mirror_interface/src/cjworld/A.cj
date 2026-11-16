// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M & Checker {
    public init() {
        println("cj: A()")
    }

    public func check(): Unit {
        println("cj: I implement Checker method `check`")
        var sut = M()
        
        println("cj: call method directly on M class")
        sut.fooRetObjCIdWithArg0AndArg1(sut, this)
        
        println("cj: call overridden method of ProtoM interface")
        fooRetObjCIdWithArg0(idProp)

        println("cj: call not overridden method of ProtoM interface")
        fooRetProtoM1WithArg0(protoProp)

        println("cj: call identity on protoField")
        protoField.identity()

        println("cj: call identity on sProtoProp")
        A.sProtoProp.identity()
    }

    public func identity() {
        println("cj: I'm a class A instance")
        println("cj: Now, I will call super.identity()")
        super.identity()
    }

    public func fooRetObjCIdWithArg0(arg0: ObjCId): ObjCId {
        println("cj: func fooRetObjCIdWithArg0(arg0: ObjCId)")
        println("cj: Now, I will call super.fooRetObjCIdWithArg0")
        super.fooRetObjCIdWithArg0(arg0)

        this
    }
}
