// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
open class A {
    private prop a: Int64 {
        get() {1}
    }
}
class B <: A {
    public var a: Int64 = 0
    public init() {
    }
}

main() {
    let b = B()
    b.a
}