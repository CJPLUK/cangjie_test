// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Forced casts inside a lambda that is passed as a call argument. Such lambda
// bodies are re-type-checked during overload resolution / generic inference, so
// the forced-cast desugaring must produce references that still resolve on the
// second pass (a regression: the runtime type reference used to lose its scope
// and fail with "not collected in symbol table"). Covers generic and concrete
// targets; bare / subscript / member operands; ArrayList initializers, user
// callbacks and trailing closures; nesting; and multiple casts in one lambda.

import std.collection.ArrayList

class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> { return e }
    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> { return e }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> { return e }
    public static func fromExtern<R>(h: Extern<DummyRT>): R { return (Extern<DummyRT>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRT> { return Extern<DummyRT>(v) }
}

func ext(v: Int64): Extern<DummyRT> {
    return Extern<DummyRT>(v)
}

// A callback taker: the lambda argument is checked against `f`'s expected type.
func apply<T>(e: Extern<DummyRT>, f: (Extern<DummyRT>) -> T): T {
    return f(e)
}

// The original failing shape: the outer function's own type parameter `T` is the
// forced-cast target inside a call-argument (ArrayList initializer) lambda.
func toList<T>(e: Extern<DummyRT>, n: Int64): ArrayList<T> {
    return ArrayList<T>(n, {_: Int64 => (T)e[0]})
}

// Generic target forwarded through another call-argument lambda.
func viaCallback<T>(e: Extern<DummyRT>): T {
    return apply<T>(e, {x => (T)x[0]})
}

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception("forced cast in lambda argument failed: " + msg)
    }
}

main() {
    // 1. Original shape: generic `(T)e[i]` in an ArrayList initializer lambda.
    let l1 = toList<Int64>(ext(7), 3)
    check(l1[0] == 7 && l1[1] == 7 && l1[2] == 7, "generic subscript in ArrayList lambda")

    // 2. Concrete target, subscript operand, in a user callback lambda.
    check(apply<Int64>(ext(11), {e => (Int64)e[0]}) == 11, "concrete subscript in callback")

    // 3. Bare operand (no subscript / member).
    check(apply<Int64>(ext(13), {e => (Int64)e}) == 13, "bare operand")

    // 4. Member-access operand.
    check(apply<Int64>(ext(17), {e => (Int64)e.field}) == 17, "member operand")

    // 5. Generic target `(T)` forwarded through a callback lambda.
    check(viaCallback<Int64>(ext(19)) == 19, "generic target via callback")

    // 6. Nested lambda: forced cast in an inner lambda inside the argument lambda.
    check(apply<Int64>(ext(23), {e => ({=> (Int64)e})()}) == 23, "nested lambda")

    // 7. Multiple forced casts in one argument lambda.
    check(apply<Int64>(ext(29), {e => (Int64)e[0] + (Int64)e.x}) == 58, "two casts in one lambda")

    // 8. Trailing-closure call form.
    check(apply<Int64>(ext(31)) {e => (Int64)e} == 31, "trailing closure")

    println("forced cast in lambda arguments: OK")
}
