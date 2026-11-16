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
    public init() {}

    public func checkMemberFunc(n: Int32) {
        try {
            super.memberFuncNotImplemented(n)
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch super.memberFuncNotImplemented ObjCOptionalMethodUnimplementedException")
        }

        try {
            super.memberFuncImplemented(n)
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch super.memberFuncImplemented ObjCOptionalMethodUnimplementedException")
        }

        try {
            this.memberFuncNotImplemented(n)
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch this.memberFuncNotImplemented ObjCOptionalMethodUnimplementedException")
        }

        try {
            this.memberFuncImplemented(n)
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch this.memberFuncImplemented ObjCOptionalMethodUnimplementedException")
        }
    }

    public static func checkStaticFunc() {
        try {
            M.staticFuncNotImplemented()
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch M.staticFuncNotImplemented ObjCOptionalMethodUnimplementedException")
        }

        try {
            M.staticFuncImplemented()
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch M.staticFuncImplemented ObjCOptionalMethodUnimplementedException")
        }

        try {
            A.staticFuncNotImplemented()
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch A.staticFuncNotImplemented ObjCOptionalMethodUnimplementedException")
        }

        try {
            A.staticFuncImplemented()
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: catch A.staticFuncImplemented ObjCOptionalMethodUnimplementedException")
        }
    }

    public func memberFuncImplemented(n: Int32) {
        println("cj: implement memberFuncImplemented(${n})")
    }

    public func memberFuncNotImplemented(n: Int32) {
        println("cj: implement memberFuncNotImplemented(${n})")
    }

    public static func staticFuncImplemented() {
        println("cj: implement staticFuncImplemented")
    }

    public static func staticFuncNotImplemented() {
        println("cj: implement staticFuncNotImplemented")
    }
}
