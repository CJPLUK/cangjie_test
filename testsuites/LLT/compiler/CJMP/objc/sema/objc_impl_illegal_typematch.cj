// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan error: Objective-C interoperability feature 'multiple type patterns inside match case (_: A | _: B)' is not yet supported

import objc.lang.*

@ObjC
public class N <: M {
    init() {}

    @ForeignName["test:"]
    public func test(arg: M): Unit {
        match (arg) {
            case _: N | _: L => println("N or L")
            case _ => println("_")
        }
    }
}

@ObjC
public open foreign class M {
    init()
}

public class L {}
