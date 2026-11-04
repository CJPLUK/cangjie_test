// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args
// EXEC: %compiler %local %f -o %output -O2 --fno-chir-function-inlining
// EXEC: %run %run_opt %output %run_args

exclave func f<T>(x: T @local!): Unit {
    let p: String @local! = "hello"
    let a = Array<String>(1000, repeat: p) @local!
    a[438] = "world"
    println(a[438])
}
func g() {
    f(5)
}
main() {
    g()
}
