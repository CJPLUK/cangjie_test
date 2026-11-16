// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {

    @ForeignGetterName["isDoc"]
    @ForeignSetterName["putDoc:"]
    public mut prop doc: Bool {
        get() {
            println("cj: doc get");
            false
        }
        set(value) {
            println("cj: doc set");
        }
    }

    public init() {
        println("cj: A()")

        foo = 1
        println("cj: foo = ${foo}");
        println("cj: bar = ${bar}");

        baz = 3
        println("cj: baz = ${baz}");

        qux = true
        println("cj: qux = ${qux}");

        car = 5
        println("cj: car = ${car}");

        hat = 6
        println("cj: hat = ${hat}")
    }
}
