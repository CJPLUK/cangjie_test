// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.ArrayList

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "length" =>
                let a = (getPayload(e) as Array<Int64>).getOrThrow()
                Extern<DummyRT>(a.size)
            case _ => throw Exception("memberAccess not implemented")
        }
    }
    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>((getPayload(e) as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
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
            case _: Option<Int64>  => (getPayload(h) as R).getOrThrow()
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

func convertArrayToArrayList<T>(array: Extern<DummyRT>): ArrayList<T> {
    let arrayLength: Extern<DummyRT> = array.length
    let arrayLengthInt64: Int64 = DummyRT.fromExtern<Int64>(arrayLength)
    ArrayList<T>(arrayLengthInt64, { i: Int64 =>
        DummyRT.fromExtern<T>(array[i])
    })
}

main () {
    let a = [1, 2, 3]
    let e = Extern<DummyRT>(a)
    let al = convertArrayToArrayList<Int64>(e)
    if (al.size != 3) {
        throw Exception("size is not 3")
    }
    if (al[0] != 1) {
        throw Exception("al[0] is not 1")
    }
    if (al[1] != 2) {
        throw Exception("al[1] is not 2")
    }
    if (al[2] != 3) {
        throw Exception("al[2] is not 3")
    }
    println("al=${al}")
    return 0
}