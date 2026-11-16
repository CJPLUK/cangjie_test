/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    private var a: S = S()
    public mut prop s: S {
        get() { a }
        set(v) { a = v }
    }
    public init() {
        var s1 = S()
        s1.x = 1
        s1.y = 1
        s = s1
    }
}
