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
    public init() {
        var m1 = M.initWithAAndBAndC(1, 2, 3)
        var m2 = M.initWithA1AndBAndC(1, 1, 1)
    }
}
