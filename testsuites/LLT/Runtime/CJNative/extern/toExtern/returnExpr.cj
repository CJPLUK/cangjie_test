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

func retInt(): Extern<DummyRT> {
    return 11
}

func retFloat(): Extern<DummyRT> {
    return 1.5
}

func retNamed(n: Int64): Extern<DummyRT> {
    return n
}

func bodyInt(): Extern<DummyRT> {
    13
}

func bodyFloat(): Extern<DummyRT> {
    1.5
}

func bodyNamed(n: Int64): Extern<DummyRT> {
    n
}

func bodyIf(c: Bool): Extern<DummyRT> {
    if (c) {
        12
    } else {
        0
    }
}

func retExisting(e: Extern<DummyRT>): Extern<DummyRT> {
    return e
}

main() {
    if (DummyRT.fromExtern<Int64>(retInt()) != 11) {
        throw Exception("returned integer literal was not converted")
    }
    if (DummyRT.fromExtern<Float64>(retFloat()) != 1.5) {
        throw Exception("returned float literal was not converted")
    }
    if (DummyRT.fromExtern<Int64>(retNamed(7)) != 7) {
        throw Exception("returned named Int64 was not converted")
    }
    if (DummyRT.fromExtern<Int64>(bodyInt()) != 13) {
        throw Exception("function-body integer literal was not converted")
    }
    if (DummyRT.fromExtern<Float64>(bodyFloat()) != 1.5) {
        throw Exception("function-body float literal was not converted")
    }
    if (DummyRT.fromExtern<Int64>(bodyNamed(8)) != 8) {
        throw Exception("function-body named Int64 was not converted")
    }
    if (DummyRT.fromExtern<Int64>(bodyIf(true)) != 12) {
        throw Exception("function-body if was not converted")
    }

    let existing: Extern<DummyRT> = DummyRT.toExtern<Int64>(42)
    if (DummyRT.fromExtern<Int64>(retExisting(existing)) != 42) {
        throw Exception("returned Extern value was wrapped again")
    }
    0
}
