// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

public class Another <: ForeignRuntime<Another> {
    public static func memberAccess(e: Extern<Another>, field: String): Extern<Another> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<Another>, arg: Any): Extern<Another> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<Another>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<Another>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<Another>, args: Array<Any>): Extern<Another> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<Another>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<Another> {
        Extern<Another>(v)
    }
}

main() {
    let i: Extern<DummyRT> = 42
    if (DummyRT.fromExtern<Int64>(i) != 42) {
        throw Exception("integer literal was not converted")
    }

    let f: Extern<DummyRT> = 1.5
    if (DummyRT.fromExtern<Float64>(f) != 1.5) {
        throw Exception("float literal was not converted")
    }

    let n: Int64 = 7
    let named: Extern<DummyRT> = n
    if (DummyRT.fromExtern<Int64>(named) != 7) {
        throw Exception("named Int64 was not converted")
    }

    let text = "hi"
    let s: Extern<DummyRT> = text
    if (DummyRT.fromExtern<String>(s) != "hi") {
        throw Exception("named String was not converted")
    }

    let same: Extern<DummyRT> = i
    if (DummyRT.fromExtern<Int64>(same) != 42) {
        throw Exception("Extern value was wrapped again")
    }

    let another: Extern<Another> = i
    let output = Another.fromExtern<Extern<DummyRT>>(another)
    if (DummyRT.fromExtern<Int64>(output) != 42) {
        throw Exception("Extern value was wrapped again")
    }

    0
}
