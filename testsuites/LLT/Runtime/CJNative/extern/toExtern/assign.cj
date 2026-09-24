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

main() {
    var i: Extern<DummyRT> = DummyRT.toExtern<Int64>(0)
    i = 9
    if (DummyRT.fromExtern<Int64>(i) != 9) {
        throw Exception("integer literal assignment was not converted")
    }

    var f: Extern<DummyRT> = DummyRT.toExtern<Float64>(0.0)
    f = 1.5
    if (DummyRT.fromExtern<Float64>(f) != 1.5) {
        throw Exception("float literal assignment was not converted")
    }

    let n: Int64 = 7
    var named: Extern<DummyRT> = DummyRT.toExtern<Int64>(0)
    named = n
    if (DummyRT.fromExtern<Int64>(named) != 7) {
        throw Exception("named Int64 assignment was not converted")
    }

    var whole: Extern<DummyRT> = DummyRT.toExtern<Int64>(0)
    whole = if (true) { 12 } else { 0 }
    if (DummyRT.fromExtern<Int64>(whole) != 12) {
        throw Exception("if assignment was not converted")
    }

    let existing: Extern<DummyRT> = DummyRT.toExtern<Int64>(42)
    var same: Extern<DummyRT> = DummyRT.toExtern<Int64>(0)
    same = existing
    if (DummyRT.fromExtern<Int64>(same) != 42) {
        throw Exception("Extern value was wrapped again")
    }
    0
}
