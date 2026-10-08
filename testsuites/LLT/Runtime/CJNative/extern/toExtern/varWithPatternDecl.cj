// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The initializer of a declaration with a pattern, e.g. `let _ : Extern<T> = 42`, is converted like the one of a
// variable declaration.

var converted: String = ""

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
        converted += "${(v as Int64).getOrThrow()};"
        Extern<DummyRT>.ExternPayload(v)
    }
}

let _ : Extern<DummyRT> = 1

func check(expected: String, what: String): Unit {
    if (converted != expected) {
        throw Exception(what + ": expected '" + expected + "' but got '" + converted + "'")
    }
    converted = ""
}

main() {
    check("1;", "global wildcard")

    let _ : Extern<DummyRT> = 2
    check("2;", "let wildcard")

    var _ : Extern<DummyRT> = 3
    check("3;", "var wildcard")

    let (a, b) : (Extern<DummyRT>, Int64) = (4, 5)
    check("4;", "tuple pattern")
    if (DummyRT.fromExtern<Int64>(a) != 4 || b != 5) {
        throw Exception("tuple pattern: wrong values")
    }

    let (_, (c, _)) : (Int64, (Extern<DummyRT>, Extern<DummyRT>)) = (6, (7, 8))
    check("7;8;", "nested tuple pattern")
    if (DummyRT.fromExtern<Int64>(c) != 7) {
        throw Exception("nested tuple pattern: wrong value")
    }
    0
}
