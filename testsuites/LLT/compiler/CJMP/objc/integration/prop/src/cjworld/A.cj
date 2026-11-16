// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

var global: Float64 = 15.0

@ObjC
public class A <: M {
    public mut prop a: Int64 {
        get() {
            foo
        }
        set(value) {
            foo = value
        }
    }

    // storing M1 directly is not working right now due to escape/ARC
    private var _b_answer: Float64
    public mut prop b: M1 {
        get() {
            M1(_b_answer)
        }
        set(value) {
            _b_answer = value.answer
        }
    }

    public prop c: Bool {
        get() {
            true
        }
    }

    private prop d: Float64 {
        get() {
            3.14159
        }
    }

    public static prop e: Float64 {
        get() {
            2.7122
        }
    }
    public static mut prop f: Float64 {
        set(value) {
            global = value
        }
        get() {
            global
        }
    }

    // storing M1 directly is not working right now due to escape/ARC
    private static var _g_answer = 14.15

    public static prop g: M1 {
        get() {
            M1(_g_answer)
        }
    }

    // storing M1 directly is not working right now due to escape/ARC
    private static var _h_answer = 15.14

    public static mut prop h: M1 {
        set(value) {
            _h_answer = value.answer
        }
        get() {
            M1(_h_answer)
        }
    }

    public init() {
        println("cj: A()")

        _b_answer = 123.123
        foo = 42
        bar = M1(3.14159)
    }
}
