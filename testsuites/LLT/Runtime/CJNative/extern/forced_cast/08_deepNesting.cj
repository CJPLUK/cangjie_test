// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A 10-level deep chain of independently ambiguous forced casts. Each
// `(Extern<DummyRuntime>)(x)` is ambiguous -- forced cast (unwrap one Extern via
// fromExtern) vs ordinary constructor call `Extern<DummyRuntime>(x)` (wrap one
// more). Sema must select the forced (unwrap) interpretation at every layer
// because the operand is Extern, peeling the 10-deep handle back to the User.
// Intentionally deep; serves as a complexity/regression guard for nested
// forced-cast resolution.

class DummyRuntime <: ForeignRuntime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexedAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (Extern<DummyRuntime>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class User {
    let id: Int64
    public init(id: Int64) { this.id = id }
}

main() {
    let deep: Extern<DummyRuntime> = Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(User(42)))))))))))
    let result: User = (User)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)((Extern<DummyRuntime>)(deep))))))))))
    if (result.id != 42) {
        throw Exception("deep nested forced cast failed")
    }
}
