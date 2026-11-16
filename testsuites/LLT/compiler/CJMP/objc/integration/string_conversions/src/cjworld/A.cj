/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
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

    public static func getNSString(): NSString {
        let str = "Hello, world!"
        return NSString(str)
    }

    public static func printString(str: NSString) {
        println("cj: ${str.toString()}")
    }

    public static func lowercase(str: NSString): NSString {
        NSString(str.toString().toAsciiLower())
    }
}
