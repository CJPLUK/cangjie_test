package cjworld

import objc.lang.*

@C
public struct Point2D {
    var x: Float32
    var y: Float32

    init(x: Float32, y: Float32) {
        println("cj: Point2D(${x}, ${y})")
        this.x = x
        this.y = y
    }
}

@ObjC
public class A <: M {
    public var cjField: Point2D

    public init() {
        super()
        cjField = Point2D(1.0, 2.0)
        println("cj: A.init()")
    }

    @ForeignName["printPointCJ:"]
    public func printPointCJ(point: ObjCPointer<Point2D>): ObjCPointer<Point2D> {
        println("cj: point ${point.read().x} ${point.read().y}")
        point
    }

    @ForeignName["testPrintThroughOC"]
    public func testPrintThroughOC() {
        let cPoint = LibC.malloc<Point2D>()
        unsafe {
            cPoint.write(Point2D(50.0, 50.0))
        }
        let objcPoint = ObjCPointer<Point2D>(CPointer<Unit>(cPoint))
        let returnedPoint = super.printPointOC(objcPoint)
        println("cj: returned point ${returnedPoint.read().x} ${returnedPoint.read().y}")
    }
}
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
