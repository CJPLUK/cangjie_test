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
public open class A <: M {
    public init() {}
    public var a1 = 1
    public static var a2 = 1
    public open mut prop p1: Int64 {get(){1};set(v){v}}
    public open mut prop p2: Int64 {get(){1};set(v){v}}
    public static mut prop s_p1: Int64 {get(){1};set(v){v}}
    public static mut prop s_p2: Int64 {get(){1};set(v){v}}
    public open func f1() {1}
    public open func f2() {1}
    public static func s_f1() {1}
    public static func s_f2() {1}
}
@ObjC
public class B <: A {
    public init() {}
    public var b1 = 1
    public static var b2 = 1
    public mut prop p2: Int64 {get(){1};set(v){v}}
    public mut prop p3: Int64 {get(){1};set(v){v}}
    public static mut prop s_p2: Int64 {get(){1};set(v){v}}
    public static mut prop s_p3: Int64 {get(){1};set(v){v}}
    public func f2() {1}
    public func f3() {1}
    public static func s_f2() {1}
    public static func s_f3() {1}
}
