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

func bothInt(n: Int64): Int64 {
    n
}

func bothInt(e: Extern<DummyRT>): Int64 {
    100 + DummyRT.fromExtern<Int64>(e)
}

func bothAny(a: Any): Int64 {
    4
}

func bothAny(e: Extern<DummyRT>): Int64 {
    100 + DummyRT.fromExtern<Int64>(e)
}

main() {
    if (bothInt(42) != 42) {
        throw Exception("Int64 overload lost to Extern")
    }
    if (bothAny(42) != 4) {
        throw Exception("Any overload lost to Extern")
    }

    let existing: Extern<DummyRT> = DummyRT.toExtern<Int64>(7)
    if (bothInt(existing) != 107) {
        throw Exception("Extern argument did not select the Extern overload")
    }
    if (bothAny(existing) != 107) {
        throw Exception("Extern argument did not select the Extern overload over Any")
    }
    0
}
