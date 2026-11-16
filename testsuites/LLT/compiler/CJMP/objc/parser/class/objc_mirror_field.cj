// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt

// ASSERT: scan-not error

import objc.lang.*

@ObjC
open foreign class M {
    init()
    // primitive
    public let x: Int64
    public var xm: Int64
    // mirror
    public let y: M
    public var ym: M
    // impl
    public let a: A
    public var am: A
}

@ObjC
class A <: M {}
