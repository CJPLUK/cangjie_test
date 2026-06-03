// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %output


public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented") 
    }
    public static func indexAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw Exception("indexAccess not implemented")
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        throw Exception("fromExtern not implemented")
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    var e = Extern<DummyRT>(1)
    var payload = getPayload(e)
    println((payload as Int64).getOrThrow())
    if ((payload as Int64).getOrThrow() != 1) {
        throw Exception("payload is not 1")
    }

    e = Extern<DummyRT>("hello world")
    payload = getPayload(e)
    println((payload as String).getOrThrow())
    if ((payload as String).getOrThrow() != "hello world") {
        throw Exception("payload is not hello world")
    }

    e = Extern<DummyRT>(true)
    payload = getPayload(e)
    println((payload as Bool).getOrThrow())
    if ((payload as Bool).getOrThrow() != true) {
        throw Exception("payload is not true")
    }

    e = Extern<DummyRT>(42.0)
    payload = getPayload(e)
    println((payload as Float64).getOrThrow())
    if ((payload as Float64).getOrThrow() != 42.0) {
        throw Exception("payload is not 42.0")
    }

    let a: Array<Int64> = [1, 2, 3]
    e = Extern<DummyRT>(a)
    payload = getPayload(e)
    println((payload as Array<Int64>).getOrThrow())
    if ((payload as Array<Int64>).getOrThrow() != a) {
        throw Exception("payload is not a")
    }

    0
}