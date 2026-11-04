// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct F <: Copyable {
    let a = 1
    let b = 2.8
    let c = 1u32
    let d = (1u32, ())
    let e = VArray<Int, $4> { i => i}

    init() {}
}

func foo(): F@local! {
    let k: F@~local = F()
    k
}

main() {
    let a: F@local! = F()
    foo()
    let b: F@~local = a 
    b.a - 1
}