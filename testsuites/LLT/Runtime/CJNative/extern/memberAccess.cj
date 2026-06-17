// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "id" => e
            case "pi" => Extern<DummyRT>(3.14)
            case "add"=> Extern<DummyRT>((getPayload(e) as Int64).getOrThrow() + 1)
            case "sub"=> Extern<DummyRT>((getPayload(e) as Int64).getOrThrow() - 1)
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexAccess not implemented")
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
            case _: Option<Float64> => (getPayload(h) as R).getOrThrow()
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let e = Extern<DummyRT>(0)

    if (DummyRT.fromExtern<Int64>(e.id) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(e.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.add) != 1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.sub) != -1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.add.add.add.sub.sub.sub) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(e.add.add.add.sub.sub.sub.add.add.add.sub.sub.sub.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    try {
        DummyRT.fromExtern<Int64>(e.foo)
        throw Exception("Unexpected!")
    } catch (e: MemberAccessException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(e.add.add.add.sub.sub.foo)
        throw Exception("Unexpected!")
    } catch (e: MemberAccessException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(e.add.add.foo.add.sub.sub)
        throw Exception("Unexpected!")
    } catch (e: MemberAccessException) {
        // Expected
    }

    0
}