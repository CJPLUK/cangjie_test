// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw ExternFunctionCallException()
    }

    public static var conversions = 0

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        conversions++
        Extern<DummyRT>(v)
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
