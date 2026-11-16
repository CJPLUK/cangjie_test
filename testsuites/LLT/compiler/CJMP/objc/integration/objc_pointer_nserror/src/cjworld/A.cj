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

    @ForeignName["testWithNumber:"]
    public static func testWithNumber(number: ?NSNumber) {
        println("cj: A.testWithNumber()")

        let marker = TrackedObject()
        markerList.add(marker)

        let checker = NumChecker()
        unsafe {
            let errCPtr = LibC.malloc<CPointer<Unit>>()
            errCPtr.write(0, CPointer<Unit>())
            let err = ObjCPointer<?NSError>(CPointer<Unit>(errCPtr))

            let num = checker.checkWithNumberAndError(number, err)
            match (num) {
                case Some(num) => 
                    println("cj: checkWithNumberAndError passed with ${num.intValue()}")
                case _ =>
                    let getErr = err.read().getOrThrow()
                    println("cj: checkWithNumberAndError failed with code: ${getErr.code()}, domain: ${getErr.domain().toString()}")
            }

            LibC.free(errCPtr)
        }

        markerList.remove(at: 0)
        gc()
    }
}
