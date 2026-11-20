// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Deferring inference constraints for concrete types containing Extern must
// preserve argument checking, overload selection and conversion side effects.
// Array parameters are deliberately not last, except in the variadic test.

var conversions = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(_: Extern<RT>, _: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(_: Extern<RT>, _: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(_: Extern<RT>, _: String, _: Any): Unit {}
    public static func indexedUpdate(_: Extern<RT>, _: Any, _: Any): Unit {}
    public static func functionCall(_: Extern<RT>, _: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { (Extern.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(value: R): Extern<RT> {
        conversions++
        Extern<RT>(value)
    }
}

func check(ok: Bool, count: Int64, name: String): Unit {
    if (!ok || conversions != count) {
        throw Exception("${name}: ok=${ok}, conversions=${conversions}, expected ${count}")
    }
    conversions = 0
}

func arrayChoice<T>(_: Array<Extern<RT>>, _: T): Int64 { 1 }
func arrayChoice<T>(_: Any, _: T): Int64 { 2 }
func tupleChoice<T>(_: (Extern<RT>, Int64), _: T): Int64 { 1 }
func tupleChoice<T>(_: Any, _: T): Int64 { 2 }
func functionChoice<T>(_: () -> Extern<RT>, _: T): Int64 { 1 }
func functionChoice<T>(_: Any, _: T): Int64 { 2 }

class Box<T> {
    let value: T
    init(value: T) { this.value = value }
}
func boxChoice<T>(_: Box<Extern<RT>>, _: T): Int64 { 1 }
func boxChoice<T>(_: Any, _: T): Int64 { 2 }

func ints(): Array<Int64> { [1, 2] }
func plain(): Int64 { 7 }
func nested<T>(x: Array<(Extern<RT>, Int8)>, _: T): Int64 {
    RT.fromExtern<Int64>(x[0][0]) + Int64(x[0][1])
}
func invoke<T>(f: () -> (Extern<RT>, Int8), _: T): Int64 {
    let pair = f()
    RT.fromExtern<Int64>(pair[0]) + Int64(pair[1])
}

// A candidate can convert a literal during checking and then fail on another
// argument. It must not leave the literal converted for the successful overload.
func laterFailure<T>(_: Array<Extern<RT>>, _: T, _: String): Int64 { 1 }
func laterFailure<T>(_: Array<Int64>, _: T, _: Bool): Int64 { 2 }
func laterLambdaFailure<T>(_: () -> Extern<RT>, _: T, _: String): Int64 { 1 }
func laterLambdaFailure<T>(f: () -> Int64, _: T, _: Bool): Int64 { f() }

func variadic<T>(_: T, xs: Array<Extern<RT>>): Bool {
    xs.size == 1 && Extern.getPayload(xs[0]) is Array<Int64>
}

main() {
    check(arrayChoice([1, 2], 0) == 1, 2, "literal elements")
    check(arrayChoice(if (true) { [3] } else { [4] }, 0) == 1, 1, "branch literal")
    check(tupleChoice((1, 2), 0) == 1, 1, "tuple literal")
    check(nested([(1, 2)], 0) == 3, 1, "nested literal and native Int8")
    check(invoke({ => (1, 2) }, 0) == 3, 1, "lambda result")

    // Existing arrays, tuples, functions and nominal wrappers are not converted
    // structurally. The Any overload must win without executing toExtern.
    let array = [1, 2]
    let tuple = (1, 2)
    check(arrayChoice(array, 0) == 2, 0, "existing array")
    check(arrayChoice(ints(), 0) == 2, 0, "array returned by a call")
    check(arrayChoice(1, 0) == 2, 0, "scalar is not an array")
    check(tupleChoice(tuple, 0) == 2, 0, "existing tuple")
    check(tupleChoice((1, "bad"), 0) == 2, 0, "unrelated tuple element")
    check(functionChoice(plain, 0) == 2, 0, "existing function")
    check(boxChoice(Box<Int64>(1), 0) == 2, 0, "nominal wrapper")
    check(laterFailure([1, 2], 0, true) == 2, 0, "discard failed candidate")
    check(laterLambdaFailure({ => 2 }, 0, true) == 2, 0, "discard failed lambda candidate")

    // A trailing Array parameter also supports variadic packing. This call
    // converts the entire array once and passes a singleton Array<Extern<RT>>.
    check(variadic(0, array), 1, "variadic whole-array conversion")
}
