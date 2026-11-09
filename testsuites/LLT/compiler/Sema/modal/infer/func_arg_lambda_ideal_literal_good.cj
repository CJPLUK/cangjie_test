// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A literal in the implicit-return position of a lambda that is a direct argument of a generic call
// keeps its ideal literal type while generic type argument inference can still resolve it. When the
// callee's formal is the type variable itself, the solved type argument is the lambda's own inferred
// type, which carries that ideal type in its return type; an unresolved one has to default to Int64
// here (Float64 for a float literal) by the end of Sema, and the lambda has to stay usable as a
// () -> Int64 or () -> Float64 value.
// Resolved by context: the ideal literal type of the argument adopts the formal's return type, so
// the Int64 default must not win over the contextual Int8.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class Holder<T> {
    let get: T
    init(x: T) { get = x }
}

func id<T>(x: T): T { x }

func takeInt8(f: () -> Int8): Int8 { f() }

main() {
    // Generic class constructor whose formal is the type variable.
    let holder = Holder({=> 1})
    let one: Int64 = holder.get()
    println(one)
    // Enum constructor 'Some' declares its parameter as the type variable too.
    let opt = Some({=> 2})
    let two: Int64 = opt.getOrThrow()()
    println(two)
    // Generic function with the type variable as its only formal.
    let three: Int64 = id({=> 3})()
    println(three)
    // The lambda type is the argument's own type at two levels of generic calls.
    let four: Int64 = id(id({=> 4}))()
    println(four)
    // Annotated lambda parameter whose body is the bare literal, i.e. the pending ideal sits in a
    // lambda that has a parameter list.
    let annotated = Holder({i: Int64 => 100})
    let hundred: Int64 = annotated.get(0)
    println(hundred)
    // Floating point ideal literal, the default is Float64.
    let floating = Holder({=> 1.5})
    let pointFive: Float64 = floating.get()
    println(pointFive)
    // The contextual return type resolves the literal, the Int64 default must not apply here.
    let eight: Int8 = takeInt8({=> 5})
    println(eight)
    return 0
}

/* SCAN
1
2
3
4
100
1.500000
5
*/
