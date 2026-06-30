// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args


public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented") 
    }
    public static func indexAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        Extern<DummyRT>(0)
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any) : Unit  {
        ()
    }
    public static func indexUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (Extern<DummyRT>.getPayload(h)) {
            case v: Int64 => (v as R).getOrThrow()
            case _ => throw Exception("fromExtern: invalid Extern value")
        }
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func foo<T>(e: Extern<T>) where T <: Runtime<T> {
    return e[0]
}

main () {
    foo<DummyRT>(Extern<DummyRT>(0))
    0
}