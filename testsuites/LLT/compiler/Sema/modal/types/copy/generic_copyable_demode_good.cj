// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args | compare %f

func toPlain<T>(v: T @local!): T where T <: Copyable {
    v
}

func toPlainTuple<T>(v: (T, T) @local!): (T, T) where T <: Copyable {
    v
}

main() {
    let x: Int64 @local! = 1
    let y: Int64 = toPlain(x)
    let t: (Int64, Int64) @local! = (2, 3)
    let u: (Int64, Int64) = toPlainTuple(t)
    println("${y} ${u[0]} ${u[1]}")
}

/* SCAN
1 2 3
*/
