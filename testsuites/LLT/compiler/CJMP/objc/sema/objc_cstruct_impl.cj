// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import objc.lang.*

@ObjC
public class Line <: Shape {
    public var start: Point2D
    public var end: Point2D

    public init(start: Point2D, end: Point2D) {
        this.start = start
        this.end = end
    }
}

@C
public struct Point2D {
    var x: Float32
    var y: Float32

    init(x: Float32, y: Float32) {
        this.x = x
        this.y = y
    }
}

@ObjC
public open foreign class Shape {
    init()
}
