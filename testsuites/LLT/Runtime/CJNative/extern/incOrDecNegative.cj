// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-14 expected 'integer type', found 'Struct-Extern<Class-RT>'
// ASSERT: scan-1 expected 'integer type', found 'Struct-Extern<Generics-T>'
// ASSERT: scan-not Assertion

// The operand of ++ and -- must be of an integer type. A dynamic member access e.f or index access e[i] of a value e
// of type Extern<T> has type Extern<T>, so it is reported like any other operand of type Extern<T>.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

class Holder {
    var field: Extern<RT> = Extern<RT>(0)
}

func generic<T>(e: Extern<T>): Unit where T <: ForeignRuntime<T> {
    e.f++
}

main() {
    var e = Extern<RT>(0)
    let holder = Holder()
    let arr = [e]
    e++                 // Variable.
    e.f++               // Dynamic member access.
    e.f--
    e[0]++              // Dynamic index access.
    e[0, 1]--
    e.f.g++             // Nested dynamic accesses.
    e[0][1]--
    e.f[0]++
    e[0].f--
    e[e.i]++            // Index of type Extern<RT>.
    holder.field++      // Field of type Extern<RT>.
    holder.field.f--
    arr[0]++            // Element of type Extern<RT>.
    let captured = e
    let f = { => captured.f++ } // In a lambda.
    0
}
