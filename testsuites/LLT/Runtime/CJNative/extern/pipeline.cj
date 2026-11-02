// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// x |> e with e: Extern<T> is the dynamic call e(x): T.functionCall(e, [x]). It is not a call of a member "()" of e.

var log = ""

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException("unexpected member access: " + field)
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

    // The callee is a function Int64 -> Int64, the result is wrapped.
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        log += "call;"
        let f = (Extern<DummyRT>.getPayload(e) as (Int64) -> Int64).getOrThrow()
        Extern<DummyRT>(f((args[0] as Int64).getOrThrow()))
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern<DummyRT>.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func pipeGeneric<T>(x: Int64, e: Extern<T>): Extern<T> where T <: ForeignRuntime<T> {
    x |> e
}

func unwrap(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func arg(x: Int64): Int64 {
    log += "arg;"
    x
}

func callee(e: Extern<DummyRT>): Extern<DummyRT> {
    log += "callee;"
    e
}

main() {
    let inc = Extern<DummyRT>({x: Int64 => x + 1})
    if (unwrap(1 |> inc) != 2) {
        throw Exception("pipeline call failed")
    }
    if (unwrap(pipeGeneric(5, inc)) != 6) {
        throw Exception("generic pipeline call failed")
    }
    if ((1 |> inc |> unwrap) != 2) {
        throw Exception("chained pipeline call failed")
    }
    log = ""
    let r = arg(3) |> callee(inc)
    if (unwrap(r) != 4 || log != "arg;callee;call;") {
        throw Exception("unexpected evaluation order: " + log)
    }
    0
}
