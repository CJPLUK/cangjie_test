// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A runtime type may declare overloads of the `ForeignRuntime` operations. Desugaring must call
// the implementations of the `ForeignRuntime<T>` members, even if an overload is declared first.

public class RT <: ForeignRuntime<RT> {
    public static func toExtern(v: Int64): Int64 {
        v
    }
    public static func memberAccess(e: Extern<RT>, field: Int64): Extern<RT> {
        throw Exception("memberAccess overload called")
    }
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> {
        Extern<RT>("member ${field}")
    }
    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> {
        throw Exception("indexedAccess not implemented")
    }
    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(e: Extern<RT>, field: Any, value: Any): Unit {
        throw Exception("indexedUpdate not implemented")
    }
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<RT>): R {
        (Extern<RT>.getPayload(h) as R).getOrThrow()
    }
    public static func toExtern<R>(v: R): Extern<RT> {
        Extern<RT>(v)
    }
}

func one(): Extern<RT> {
    1
}

main() {
    let e = one()
    if ((Extern<RT>.getPayload(e) as Int64).getOrThrow() != 1) {
        throw Exception("toExtern overload called")
    }
    let m = e.foo
    if ((Extern<RT>.getPayload(m) as String).getOrThrow() != "member foo") {
        throw Exception("unexpected member access result")
    }
    0
}
