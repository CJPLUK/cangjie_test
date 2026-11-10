// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 type of left operand does not support coalescing operation
// ASSERT: scan-1 expected 'Int64', found 'Struct-Extern<Class-RT>'
// ASSERT: scan-1 undeclared identifier 'nope'
// ASSERT: scan-1 invalid binary operator '+' on type 'Int64' and 'Struct-String'
// ASSERT: scan-2 implicit conversion to 'Extern' is not allowed in 'const' code
// ASSERT: scan-1 expected 'const' expression guaranteed to be evaluated at compile time
// ASSERT: scan 7 errors generated

public class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(v: R): Extern<RT> { Extern<RT>(v) }
}

const func constCoalescing(o: ?Extern<RT>): Extern<RT> {
    o ?? 1                                       // error: conversion in const code
}

const func constCoalescingExtern(o: ?Extern<RT>, e: Extern<RT>): Extern<RT> {
    o ?? e                                       // OK, no conversion
}

main() {
    let e = Extern<RT>(0)
    let none: ?Extern<RT> = None
    let notOption = e ?? 8                       // error: the left operand is not an Option
    let i: Int64 = none ?? 8                     // error: none ?? 8 has type Extern<RT>
    let undefined: Extern<RT> = none ?? nope     // error: undeclared identifier
    let illTyped: Extern<RT> = none ?? (1 + "a") // error: ill-typed right operand
    const c: Extern<RT> = none ?? 1              // errors: not a const expression, conversion in const code
    0
}
