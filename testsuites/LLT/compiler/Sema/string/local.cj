// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func foo() {
    let a: Int64 @local! = 3
    let b: Float64 @local! = 3.14
    let c: Rune @local! = r'c'
    let d: Bool @local! = true
    let e: String @local! = "haha"

    let p = "${a} ${b} ${c} ${d} ${e}"
    println(p)

    let q: ToString @local! = "${a} ${b} ${c} ${d} ${e}"
    let r: String @local? = "${a} ${b} ${c} ${d} ${e}"
    bar("${a} ${b} ${c} ${d} ${e}")
    bar2("${a} ${b} ${c} ${d} ${e}")
}
func bar(_: String @local!) {}
func bar2(_: String @local?) {}

main() {
    foo()
    0
}