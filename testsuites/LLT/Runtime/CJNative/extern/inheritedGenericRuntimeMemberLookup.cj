// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class AccessBase<E> {
    public static func memberAccess(e: E, name: String): E { e }
}

class RT <: AccessBase<Extern<RT>> & ForeignRuntime<RT> {
    // Other required members; none is called by this example.
    public static func toExtern<T>(value: T): Extern<RT> { throw Exception() }
    public static func fromExtern<T>(e: Extern<RT>): T { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit { throw Exception() }
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit { throw Exception() }
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
}

main() {
    let e = Extern<RT>(7)
    let actual = e.value
    if ((Extern<RT>.getPayload(actual) as Int64).getOrThrow() != 7) {
        throw Exception("unexpected member payload")
    }
    0
}
