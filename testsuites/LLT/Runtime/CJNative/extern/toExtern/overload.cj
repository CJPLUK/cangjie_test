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
