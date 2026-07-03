// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Positive: chained parenthesized forms `(X)(Y)(Z)...` parse LEFT-associatively,
// i.e. `((X)(Y))(Z)`, matching ordinary call chains and stock Cangjie. A trailing
// postfix (`(args)`, `[i]`, `.member`) binds to the RESULT of the forced cast, not
// to its operand. This file pins the well-formed groupings that must keep working
// (and keep producing the right runtime values); the sibling negative test
// `18_negativeAmbiguousChaining.cj` pins the ill-formed ones. Both guard against
// the nested-ambiguity ICE that right-associative speculation used to trigger.

class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> { return e }
    public static func indexAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> { return e }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> { return e }
    public static func fromExtern<R>(h: Extern<DummyRT>): R { return (Extern<DummyRT>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRT> { return Extern<DummyRT>(v) }
}

func ext(v: Int64): Extern<DummyRT> { return Extern<DummyRT>(v) }
func extS(v: String): Extern<DummyRT> { return Extern<DummyRT>(v) }
func extA(v: Array<Int64>): Extern<DummyRT> { return Extern<DummyRT>(v) }

func foo(x: Int64): Int64 { return x + 100 }
func curry(x: Int64): (Int64) -> Int64 { return { y => x + y } }
func curry3(x: Int64): (Int64) -> (Int64) -> Int64 { return { y => { z => x + y + z } } }

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception("left-associative chaining failed: " + msg)
    }
}

main(): Int64 {
    // --- continuous association: value-form call chains group left ---
    // `(curry)(1)(2)` == `((curry)(1))(2)` == curry(1)(2)
    check((curry)(1)(2) == 3, "curried 2-level")
    check((curry3)(1)(2)(3) == 6, "curried 3-level")
    // a single parenthesized callee still reads as a plain call
    check((foo)(5) == 105, "single fallback call")

    // --- a forced cast followed by a postfix binds to the CAST RESULT ---
    // `(Array<Int64>)(extA(..))[1]` == `((Array<Int64>)(extA(..)))[1]`
    check((Array<Int64>)(extA([10, 20, 30]))[1] == 20, "cast then subscript")
    // `(String)(extS(..)).size` == `((String)(extS(..))).size`
    check((String)(extS("hi")).size == 2, "cast then member")

    // --- forced casts compose with arithmetic / as call arguments ---
    check((Int64)(ext(3)) + (Int64)(ext(4)) == 7, "two casts in arithmetic")
    check(foo((Int64)(ext(5))) == 105, "cast as call argument")

    // --- nesting: a forced cast used as another cast's operand ---
    // inner `(Int64)(ext(9))` feeds `ext(..)`, then the outer cast unwraps it
    check((Int64)(ext((Int64)(ext(9)))) == 9, "cast nested in operand")

    // --- the bare form `(U)e` still right-binds to the following expression ---
    check((Int64)ext(8) == 8, "bare forced cast")
    // redundant parentheses around the operand are transparent
    check((Int64)((ext(6))) == 6, "redundant operand parentheses")

    // --- deep and irregular multi-level nesting ---
    // `(A)((B)(C)(D))`: the outer call wraps an inner left-associative chain,
    // which stays left-associative because the disabled cast attempt is shallow
    // (it is re-enabled for the group's contents): foo(curry(1)(2)) == foo(3)
    check((foo)((curry)(1)(2)) == 103, "outer wraps inner chain")
    check((foo)((curry3)(1)(2)(3)) == 106, "outer wraps deeper inner chain")
    // three levels of explicitly nested single calls: foo(foo(foo(1)))
    check((foo)((foo)((foo)(1))) == 301, "triple explicit nesting")
    // irregular: a nested call as the first argument, then another postfix call
    // `((curry)((foo)(1)))(2)` == curry(foo(1))(2) == curry(101)(2)
    check((curry)((foo)(1))(2) == 103, "nested-call argument then postfix")
    // irregular mixed chain: `(((curry3)(1))((foo)(2)))(3)` == curry3(1)(foo(2))(3)
    check((curry3)(1)((foo)(2))(3) == 106, "mixed chain with nested argument")
    // three forced casts nested through the operand
    check((Int64)(ext((Int64)(ext((Int64)(ext(7)))))) == 7, "three nested forced casts")
    // a chain nested two calls deep: foo(foo(curry(1)(2))) == foo(foo(3)) == foo(103)
    check((foo)((foo)((curry)(1)(2))) == 203, "chain nested two calls deep")

    return 0
}
