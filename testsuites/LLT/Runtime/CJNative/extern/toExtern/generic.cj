// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (e) {
            case ExternPayload(value) => (value as R).getOrThrow()
            case _ => throw ExternConversionException("not a payload")
        }
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>.ExternPayload(v)
    }
}

func box<T>(v: Int64): Extern<T> where T <: ForeignRuntime<T> {
    v
}

func lit<T>(): Extern<T> where T <: ForeignRuntime<T> {
    42
}

main() {
    if (DummyRT.fromExtern<Int64>(box<DummyRT>(7)) != 7) {
        throw Exception("generic return of a named Int64 was not converted")
    }
    if (DummyRT.fromExtern<Int64>(lit<DummyRT>()) != 42) {
        throw Exception("generic function-body literal was not converted")
    }
    0
}
