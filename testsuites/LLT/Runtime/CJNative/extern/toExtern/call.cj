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

func onlyInt(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func onlyFloat(e: Extern<DummyRT>): Float64 {
    DummyRT.fromExtern<Float64>(e)
}

func mixed(e1: Int64, e2: Extern<DummyRT>, e3: Int64, e4: Extern<DummyRT>): Int64 {
    e1 + DummyRT.fromExtern<Int64>(e2) + e3 + DummyRT.fromExtern<Int64>(e4)
}

main() {
    if (onlyInt(42) != 42) {
        throw Exception("integer literal argument was not converted")
    }
    if (onlyFloat(1.5) != 1.5) {
        throw Exception("float literal argument was not converted")
    }

    let n: Int64 = 7
    if (onlyInt(n) != 7) {
        throw Exception("named Int64 argument was not converted")
    }
    if (mixed(1, 2, 3, 4) != 10) {
        throw Exception("only Extern parameters were not converted")
    }

    let existing: Extern<DummyRT> = DummyRT.toExtern<Int64>(42)
    if (onlyInt(existing) != 42) {
        throw Exception("Extern argument was wrapped again")
    }
    0
}
