// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static var conversions = 0

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
        conversions++
        Extern<DummyRT>.ExternPayload(v)
    }
}

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func expectConversions(n: Int64, msg: String): Unit {
    check(DummyRT.conversions == n, "${msg}: ${DummyRT.conversions} conversions, expected ${n}")
    DummyRT.conversions = 0
}

func scalar(x!: Extern<DummyRT> = 42): Int64 {
    DummyRT.fromExtern<Int64>(x)
}

func array(x!: Array<Extern<DummyRT>> = [1, "two"]): String {
    DummyRT.fromExtern<String>(x[1])
}

func tuple(x!: (Extern<DummyRT>, Int64) = ("one", 2)): String {
    DummyRT.fromExtern<String>(x[0])
}

func branch(c: Bool, x!: Extern<DummyRT> = if (c) { 1 } else { "no" }): String {
    DummyRT.fromExtern<String>(x)
}

class C {
    let s: String
    init(x!: Extern<DummyRT> = "c") {
        s = DummyRT.fromExtern<String>(x)
    }
}

main() {
    check(scalar() == 42, "scalar default")
    expectConversions(1, "scalar default")

    check(scalar(x: 7) == 7, "scalar argument")
    expectConversions(1, "scalar argument")

    check(array() == "two", "array default")
    expectConversions(2, "array default")

    check(tuple() == "one", "tuple default")
    expectConversions(1, "tuple default")

    check(branch(false) == "no", "branch default")
    expectConversions(1, "branch default")

    check(C().s == "c", "constructor default")
    expectConversions(1, "constructor default")
    0
}
