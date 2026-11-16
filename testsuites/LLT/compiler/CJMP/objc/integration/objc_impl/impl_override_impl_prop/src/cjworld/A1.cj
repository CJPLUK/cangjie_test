// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
class A1 <: A {
    public prop answer: Int64 {
        get() {
            super.answer + 1
        }
    }

    public mut prop objCAnswer: Int64 {
        get() {
            super.objCAnswer * 2
        }
        set(value) {
            println("cj: A1.objCAnswer set")
            super.objCAnswer = value
        }
    }

    public init() {
        println("cj: A1()")
        objCAnswer = -100500
    }
}
