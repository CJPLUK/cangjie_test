// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*


@ObjC
public class A <: M {
    public init() {
        print("cj: A()\n", flush: true)
    }

    private static var primitiveField: Int64 = 0
    public prop primitive: Int64 {
        get() {
            print("c: A.primitive.get()\n", flush: true)
            value
        }
    }

    public mut prop primitiveMut: Int64 {
        get() {
            print("c: A.primitiveMut.get()\n", flush: true)
            primitiveField
        }
        set(value) {
            print("c: A.primitiveMut.set(${value})\n", flush: true)
            primitiveField = value
        }
    }

    public static prop primitiveStatic: Int64 {
        get() {
            print("c: A.primitiveStatic.get()\n", flush: true)
            primitiveField
        }
    }

    public static mut prop primitiveStaticMut: Int64 {
        get() {
            print("c: A.primitiveStaticMut.get()\n", flush: true)
            primitiveField
        }
        set(value) {
            print("c: A.primitiveStaticMut.set(${value})\n", flush: true)
            primitiveField = value
        }
    }

    public prop mirror: M {
        get() {
            print("c: A.mirror.get()\n", flush: true)
            M()
        }
    }

    private var mirrorField: M = M()
    public mut prop mirrorMut: M {
        get() {
            print("c: A.mirrorMut.get()\n", flush: true)
            mirrorField
        }
        set(value) {
            print("c: A.mirrorMut.set(M(${value.value}))\n", flush: true)
            mirrorField = value
        }
    }

    public static prop mirrorStatic: M {
        get() {
            print("c: A.mirrorStatic.get()\n", flush: true)
            M()
        }
    }

    public static mut prop mirrorStaticMut: M {
        get() {
            print("c: A.mirrorStaticMut.get()\n", flush: true)
            M()
        }
        set(value) {
            print("c: A.mirrorStaticMut.set(M(${value.value}))\n", flush: true)
        }
    }

    public prop mirrorSelf: M {
        get() {
            print("c: A.mirrorSelf.get()\n", flush: true)
            this
        }
    }

    public prop implSelf: A {
        get() {
            print("c: A.implSelf.get()\n", flush: true)
            this
        }
    }

    private static var implField: ?A = None
    public prop impl: A {
        get() {
            print("c: A.impl.get()\n", flush: true)
            implField ?? throw Exception("Can't call impl constructor")
        }
    }

    public static prop implStatic: A {
        get() {
            print("c: A.implStatic.get()\n", flush: true)
            implField ?? throw Exception("Can't call impl constructor")
        }
    }

    public mut prop implMut: A {
        get() {
            print("c: A.implMut.get()\n", flush: true)
            implField ?? throw Exception("Can't call impl constructor")
        }
        set(value) {
            print("c: A.implMut.set(A(${value.value}))\n", flush: true)
            implField = value
        }
    }

    public static mut prop implStaticMut: A {
        get() {
            print("c: A.implStaticMut.get()\n", flush: true)
            implField ?? throw Exception("Can't call impl constructor")
        }
        set(value) {
            print("c: A.implStaticMut.set(A(${value.value}))\n", flush: true)
            implField = value
        }
    }
}
