// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.HashMap

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(_: Extern<DummyRT>, _: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented")
    }
    public static func indexedAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as Array<Rune>).getOrThrow()[(index as Int64).getOrThrow()])
        } else if (index is UInt32) {
            let payload = (Extern<DummyRT>.getPayload(e) as Array<Int32>).getOrThrow()
            Extern<DummyRT>(payload[Int64((index as UInt32).getOrThrow())])
        } else if (index is String) {
            Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as HashMap<String, UInt32>).getOrThrow()[(index as String).getOrThrow()])
        } else if (index is Int32) {
            Extern<DummyRT>((Extern<DummyRT>.getPayload(e) as HashMap<Int32, Array<Int32>>).getOrThrow()[(index as Int32).getOrThrow()])
        } else {
            throw Exception("indexedAccess not implemented")
        }
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexedUpdate not implemented")
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
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let a : Array<Rune> = [r'a', r'b', r'c']
    let e = Extern<DummyRT>(a)

    if (DummyRT.fromExtern<Rune>(e[0]) != r'a') {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Rune>(e[1]) != r'b') {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Rune>(e[2]) != r'c') {
        throw Exception("Unexpected!")
    }

    let h = HashMap<String, UInt32>()
    h["one"] = 1
    h["two"] = 2
    h["three"] = 3
    let f = Extern<DummyRT>(h)

    if (DummyRT.fromExtern<UInt32>(f["one"]) != 1) {
        throw Exception("Unexpected!")
    }
    if (DummyRT.fromExtern<UInt32>(f["two"]) != 2) {
        throw Exception("Unexpected!")
    }
    if (DummyRT.fromExtern<UInt32>(f["three"]) != 3) {
        throw Exception("Unexpected!")
    }
    try {
        DummyRT.fromExtern<UInt32>(f["four"])
        throw Exception("Unexpected!")
    } catch (e: NoneValueException) {
        // Expected
    }

    let m = HashMap<Int32, Array<Int32>>()
    m[1] = [1, 2, 3]
    m[2] = [4, 5, 6]
    m[3] = [7, 8, 9]
    let g = Extern<DummyRT>(m)

    let tmp = g[Int32(1)]
    if (!(Extern<DummyRT>.getPayload(tmp) is Array<Int32>)) {
        throw Exception("Unexpected!")
    }
    let payload = (Extern<DummyRT>.getPayload(tmp) as Array<Int32>).getOrThrow()
    if (payload[0] != 1 || payload[1] != 2 || payload[2] != 3) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int32>(g[Int32(1)][UInt32(0)]) != 1) {
        throw Exception("Unexpected!")
    }
    if (DummyRT.fromExtern<Int32>(g[Int32(2)][UInt32(1)]) != 5) {
        throw Exception("Unexpected!")  
    }
    if (DummyRT.fromExtern<Int32>(g[Int32(3)][UInt32(2)]) != 9) {
        throw Exception("Unexpected!")
    }
    try {
        DummyRT.fromExtern<Int32>(g[Int32(4)][UInt32(0)])
        throw Exception("Unexpected!")
    } catch (e: NoneValueException) {
        // Expected
    }
    try {
        DummyRT.fromExtern<Int32>(g[Int32(1)][UInt32(3)])
        throw Exception("Unexpected!")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }

    0
}