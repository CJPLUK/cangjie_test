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

    public static func testCreateFreshMirror(): NSObject {
        println("cj: A.testCreateFreshMirror")
        let marker = TrackedObject()
        markerList.add(marker)

        let res = M(NSString("<M: I'm created from Cangjie, u know?>"))

        markerList.remove(at: 0)
        gc()
        res
    }
}
