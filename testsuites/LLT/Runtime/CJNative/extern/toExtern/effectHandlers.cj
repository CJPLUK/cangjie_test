// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %enableEH %cmp_opt %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output %run_args

import stdx.effect.Command

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

class Ask <: Command<Int64> {}

class Stop <: Command<Unit> {}

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func expectConversions(n: Int64, msg: String): Unit {
    check(DummyRT.conversions == n, "${msg}: ${DummyRT.conversions} conversions, expected ${n}")
    DummyRT.conversions = 0
}

func body(): Extern<DummyRT> {
    try {
        let n = perform Ask()
        n + 1
    } handle (_: Ask) {
        resume with 41
    }
}

main() {
    let resumed: Extern<DummyRT> = try {
        perform Ask()
    } handle (_: Ask) {
        resume with 7
    }
    expectConversions(1, "try body")
    check(DummyRT.fromExtern<Int64>(resumed) == 7, "try body")

    let early: Extern<DummyRT> = try {
        perform Stop()
        2
    } handle (_: Stop) {
        "handler"
    }
    expectConversions(1, "handler value")
    check(DummyRT.fromExtern<String>(early) == "handler", "handler value")

    check(DummyRT.fromExtern<Int64>(body()) == 42, "function body")
    expectConversions(1, "function body")

    let caught: Extern<DummyRT> = try {
        throw Exception()
    } catch (_: Exception) {
        true
    } handle (_: Ask) {
        resume with 1
    }
    expectConversions(1, "catch block")
    check(DummyRT.fromExtern<Bool>(caught), "catch block")

    let e: Extern<DummyRT> = 5
    expectConversions(1, "Extern value")
    let same: Extern<DummyRT> = try {
        e
    } handle (_: Ask) {
        resume with 0
    }
    expectConversions(0, "Extern body was wrapped again")
    check(DummyRT.fromExtern<Int64>(same) == 5, "Extern body")

    let inArray: Array<Extern<DummyRT>> = [try {
        perform Stop()
        3
    } handle (_: Stop) {
        "element"
    }]
    expectConversions(1, "array element")
    check(DummyRT.fromExtern<String>(inArray[0]) == "element", "array element")
    0
}
