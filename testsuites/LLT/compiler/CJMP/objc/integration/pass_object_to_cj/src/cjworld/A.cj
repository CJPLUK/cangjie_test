// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package cjworld

import std.collection.*
import std.runtime.*
import objc.lang.*

@ObjC
public class A <: NSObject {
    static let markerList = ArrayList<TrackedObject>()

    @ForeignName["testPassObject:"]
    public static func testPassObject(obj: M): M {
        println("cj: A.testPassObject()")
        let marker = TrackedObject()
        markerList.add(marker)

        obj.printNumber()

        markerList.remove(at: 0)
        gc()
        obj
    }
}
