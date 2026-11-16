// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Resolve C.f through both independent roots, then dispatch via C, A, and B.
// EXEC: %compiler %cmp_opt -O0 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// EXEC: %compiler %cmp_opt -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

interface A {
    func f(): Int64
}

interface B {
    func f(): Int64
}

interface C <: A & B {
    func f(): Int64
}

struct Impl <: C {
    public func f(): Int64 { 5 }
}

func callCombined(value: C): Int64 {
    value.f()
}

main(): Int64 {
    let combined: C = Impl()
    let a: A = Impl()
    let b: B = Impl()
    if (callCombined(combined) != 5 || a.f() + b.f() != 10) {
        return 1
    }
    println("PASS")
    return 0
}

/* SCAN
PASS
*/
