// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(_: Extern<DummyRT>, _: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented") 
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
            case _: Option<Int64>  => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Float64> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _ => throw Exception("fromExtern not implemented")

        }
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func foo(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func bar(e1: Int64, e2: Extern<DummyRT>, e3: Int64, e4: Extern<DummyRT>): Int64 {
    e1 + DummyRT.fromExtern<Int64>(e2) + e3 + DummyRT.fromExtern<Int64>(e4)
}

main () {
    let e1: Extern<DummyRT> = 1
    if (DummyRT.fromExtern<Int64>(e1) != 1) {
        throw Exception("fromExtern failed for Int64")
    }

    let e2: Extern<DummyRT> = 2.234
    if (DummyRT.fromExtern<Float64>(e2) != 2.234) {
        throw Exception("fromExtern failed for Float64")
    }

    if (foo(42) != 42) {
        throw Exception("foo failed for Int64")
    }
    
    if (bar(1, 2, 3, 4) != 10) {
        throw Exception("bar failed for Int64")
    }
    0
}