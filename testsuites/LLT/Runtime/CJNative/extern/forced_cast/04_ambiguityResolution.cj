// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Ambiguity resolution. Several `(X)...` shapes are syntactically ambiguous and
// the compiler must pick the right interpretation. Two families:
//
//  1. Call/subscript vs forced cast -- `(U)(e)`, `(U)(e1,e2)`, `(U)[i]`. Both
//     interpretations consume the same tokens; the decision is made by what `U`
//     is (a type with an Extern operand -> forced cast; a function/value ->
//     ordinary call/subscript).
//
//  2. Binary operator vs forced cast -- `(X)-Y`. After `(X)`, a `-` could be a
//     binary subtraction or the unary-minus of a forced-cast operand, so the
//     parser keeps both candidates (AmbiguousForcedCastExpr) and sema selects.
//     With `X` a value the forced branch is rejected and it resolves to binary;
//     the forced branch is only viable when `X` is a type and the operand is
//     Extern (`-e` of an Extern is not defined, so in practice this family
//     resolves to binary). A forced cast may still be followed by a trailing
//     binary operator: `(Int64)(e) - 1` is `((Int64)(e)) - 1`.

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class User {
    let id: Int64
    public init(id: Int64) { this.id = id }
}

func consume(value: Extern<DummyRuntime>): User { (User)value }
func makeUserExtern(id: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(User(id)) }
func makeIntExtern(value: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(value) }
func pair(a: Int64, b: Int64): Int64 { a + b }

// Family 1: call/subscript vs forced cast, decided by U.
func checkCallVsCast(): Unit {
    let castByType: User = (User)(makeUserExtern(1))   // U is a type, operand Extern -> forced cast
    let callByFunc: User = (consume)(makeUserExtern(2)) // U is a function -> ordinary call
    let multiArgCall = (pair)(3, 4)                      // multi-argument call
    let arr = [10, 20, 30]
    let subscriptByValue = (arr)[1]                      // U is a value -> subscript
    if (castByType.id != 1 || callByFunc.id != 2 || multiArgCall != 7 || subscriptByValue != 20) {
        throw Exception("call-vs-cast resolution failed")
    }
}

// Family 2: binary operator vs forced cast.
func checkBinaryVsCast(): Unit {
    let v: Int64 = 10
    let bar: Int64 = 3
    // Ordinary ambiguity: (X)-Y with X a value resolves to binary subtraction.
    let minusMixed = (v)-1*2     // v - 1*2 = 8
    let minusVar = (v)-bar       // v - bar = 7
    let plusVar = (v)+bar        // v + bar = 13 ('+' is not a prefix unary, so never a cast operand)
    // Extern: a forced cast followed by a trailing binary minus.
    let externTrailingMinus = (Int64)(makeIntExtern(5)) - 1   // ((Int64)(e)) - 1 = 4
    if (minusMixed != 8 || minusVar != 7 || plusVar != 13 || externTrailingMinus != 4) {
        throw Exception("binary-vs-cast resolution failed")
    }
}

main() {
    checkCallVsCast()
    checkBinaryVsCast()
}
