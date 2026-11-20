// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-8 type arguments are not allowed on a dynamic member access of 'Extern'
// ASSERT: scan-2 type argument's number does not match type parameter's number
// ASSERT: scan-not expected 'integer type'
// ASSERT: scan-1 10 errors generated
// ASSERT: scan-not Assertion

// The foreign runtime only receives the name of a dynamic member, so a dynamic member access cannot have type
// arguments, whether it is read, called, used as a base, updated, compound-assigned, incremented or decremented. A
// variable of type Extern cannot have type arguments either, like any other variable.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

main() {
    let e = Extern<RT>(0)
    let read = e.f<Int64>
    let called = e.f<Int64>(1)
    let base = e.f<Int64, String>.g
    e.f<Int64> = 1
    e.f<Int64> += 1
    e.f<Int64>++
    e.f<Int64>--
    e.f.g<Int64>[0] = 1
    let variable = e<Int64>
    let variableCalled = e<Int64>(1)
    let ok = e.f(1)
    0
}
