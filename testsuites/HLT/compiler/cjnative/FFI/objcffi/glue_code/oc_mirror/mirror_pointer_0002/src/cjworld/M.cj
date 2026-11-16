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
public open foreign class M {
    public init()
    public open func goo1(): ObjCPointer<Int64>
    @ForeignName["goo2:"]
    public open func goo2(p: ObjCPointer<Int64>): ObjCPointer<Int64>
}
