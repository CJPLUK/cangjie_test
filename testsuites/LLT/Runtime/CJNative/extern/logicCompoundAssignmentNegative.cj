// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-6 type incompatible in this compound assignment expression
// ASSERT: scan-1 6 errors generated
// ASSERT: scan-not Assertion

// The operators && and || cannot be overloaded and evaluate their right operand only if needed, so &&= and ||= only
// apply to Bool. They are rejected when the left value has type Extern<T>, whether it is a variable, a field, a dynamic
// member or a dynamic index, like e && v.

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
    e.f &&= true
}

func check(): Bool {
    true
}

main() {
    var e = Extern<RT>(0)
    let holder = Holder()
    e &&= check()          // Variable.
    holder.field ||= true  // Field.
    e.f &&= check()        // Dynamic member.
    e[0] ||= false         // Dynamic index.
    e.f[0] &&= e.g         // Nested dynamic accesses.
    var b = true
    b &&= check()          // Bool is unaffected.
    b ||= check()
    0
}
