// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A Leaf-typed receiver makes CHIR resolve the shared generic root recursively.
// EXEC: %compiler %cmp_opt -O0 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// EXEC: %compiler %cmp_opt -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

interface Root<T> {
    func f(x: T): T { x }
}

interface Left<T> <: Root<T> {
    func f(x: T): T { x }
}

interface Right<T> <: Root<T> {
    func f(x: T): T { x }
}

interface Leaf <: Left<Int64> & Right<Int64> {
    func f(x: Int64): Int64 { x + 1 }
}

struct Impl <: Leaf {}

func callLeaf(value: Leaf): Int64 {
    value.f(7)
}

main(): Int64 {
    let leaf: Leaf = Impl()
    let value: Root<Int64> = leaf
    if (callLeaf(leaf) != 8 || value.f(7) != 8) {
        return 1
    }
    println("PASS")
    return 0
}

/* SCAN
PASS
*/
