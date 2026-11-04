// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A pending ideal does not adopt an upper bound a generic constraint contributes: with the
// expectation on the enclosing function's return type and the constraint on the type variable, the
// meet of the upper bounds is the constraint's interface, while the literal has to keep its own
// default Int64. The assertion pins the instantiated type down.

// EXEC: %compiler %local %noColor %cmp_opt %compile_lib_opt %f -Woff all --dump-chir --dump-to-screen | compare %f

interface Base <: ToString {}
interface Derived <: Base {}

extend Int64 <: Derived {}

func constrained<T>(x: T): T where T <: Derived { x }

func viaConstraint(): Base {
    constrained(1)
}

main() {
    let boxed: Base = viaConstraint()
    println(boxed)
    return 0
}

// ASSERT: scan-1 Int64 = Apply(
