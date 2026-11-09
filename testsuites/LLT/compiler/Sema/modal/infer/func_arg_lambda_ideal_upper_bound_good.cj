// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A literal kept pending in the implicit-return position of a lambda that is a direct argument of a
// generic call has to adopt the concrete type of the enclosing expression's upper bound instead of
// the Int64 / Float64 default. With the type variable itself as the callee's formal, that upper
// bound can be a function type - or a type argument holding one - whose numeric type the solver has
// to prefer over defaulting the pending ideal.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

func id<T>(x: T): T { x }

class Holder<T> {
    let get: T
    init(x: T) { get = x }
}

main() {
    // The upper bound is the function type taken from the variable's annotation.
    let f: () -> Int8 = id({=> 5})
    let five: Int8 = f()
    println(five)
    // Same with a floating point literal.
    let g: () -> Float32 = id({=> 2.5})
    let half: Float32 = g()
    println(half)
    // The upper bound holds the function type as a type argument.
    let h: Holder<() -> Int8> = Holder({=> 6})
    let six: Int8 = h.get()
    println(six)
    // Explicit type argument, for contrast.
    let i: () -> Int8 = id<() -> Int8>({=> 7})
    let seven: Int8 = i()
    println(seven)
    return 0
}

/* SCAN
5
2.500000
6
7
*/
