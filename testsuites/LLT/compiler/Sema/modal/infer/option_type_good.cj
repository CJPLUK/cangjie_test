// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface I {}

class A <: I {
    init() {}
    init(this @local?) { exclave { } }
}

func test(): Unit {
    let v: ?I = Some(A())
    println(v.isSome())
}

main() {
    test()
}
