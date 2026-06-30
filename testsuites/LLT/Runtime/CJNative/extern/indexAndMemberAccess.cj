// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.HashMap

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "id" => e
            case "pi" => Extern<DummyRT>(3.14)
            case "add"=> Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as Int64).getOrThrow() + 1)
            case "sub"=> Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as Int64).getOrThrow() - 1)
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
        } else if (index is String) {
            Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as HashMap<String, Array<Int64>>).getOrThrow()[(index as String).getOrThrow()])
        } else if (index is Extern<DummyRT>) {
            (index as Extern<DummyRT>).getOrThrow()
        } else {
            throw Exception("indexAccess not implemented")
        }
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Float64> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Rune> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<UInt32> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Int32> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<HashMap<String, Array<Int64>>> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let m = HashMap<String, Array<Int64>>()
    m["one"] = [1, 2, 3]
    m["two"] = [4, 5, 6]
    m["three"] = [7, 8, 9]
    let e = Extern<DummyRT>(m)

    if (DummyRT.fromExtern<Int64>(e["one"][0]) != 1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e["one"][0].id) != 1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e["one"][0].id.sub) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.id["one"][0].id.sub) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(e.id["one"][0].id.sub.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<HashMap<String, Array<Int64>>>(e.id["one"][0].id.sub.pi[e])["one"][1] != 2) {
        throw Exception("Unexpected!")
    }

    try {
        DummyRT.fromExtern<HashMap<String, Array<String>>>(e.id["one"][0].id.sub.pi[e])["one"][1]
        throw Exception("Unexpected!")
    } catch (e: ExternConversionException) {
        // Expected
    }
    0
}