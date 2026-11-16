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
    public func printPointCJ(point: Point2D): Point2D {
        println("cj: point ${point.x} ${point.y}")
        point
    }

    @ForeignName["testPrintThroughOC"]
    public func testPrintThroughOC() {
        let point = Point2D(50.0, 50.0)
        let returnedPoint = super.printPointOC(point)
        println("cj: returned point ${returnedPoint.x} ${returnedPoint.y}")
    }
}
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
