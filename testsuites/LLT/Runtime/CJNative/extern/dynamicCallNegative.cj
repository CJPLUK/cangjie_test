// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 named argument cannot be used in variable function call
// ASSERT: scan-1 'inout' can only be used in a 'CFunc' calling
// ASSERT: scan-3 undeclared identifier 'missing'
// ASSERT: scan-2 expected 'Int64', found 'Struct-Extern<Class-RT>'
// ASSERT: scan-not Assertion

// Arguments of a dynamic call e(...) are passed to the foreign runtime as Array<Any>. They cannot be named or
// 'inout', and each one must be well typed. The call and a dynamic index e[i] have type Extern<T>, so they cannot
// be used where a different type is required. An ill-typed index or value makes the dynamic update ill-typed.

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
    let e = RT.toExtern(1)
    var x = 1
    e(name: 1)
    e(inout x)
    e(missing)
    let fromCall: Int64 = e()
    let fromIndex: Int64 = e[0]
    e.field = missing
    e[missing] = 1
    0
}
