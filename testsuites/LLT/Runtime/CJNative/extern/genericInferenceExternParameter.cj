// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A parameter of type Extern<RT> accepts an argument of any type, which is converted. It does not constrain the type
// arguments inferred for a generic call, so the call and its overload resolution are the same as with explicit type
// arguments.

var conversions = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }

    public static func fromExtern<R>(e: Extern<RT>): R {
        (Extern<RT>.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(value: R): Extern<RT> {
        conversions++
        Extern<RT>(value)
    }
}

func keep<T>(value: T, e: Extern<RT>): T {
    value
}

func payload<T>(value: T, e: Extern<RT>): Int64 {
    RT.fromExtern<Int64>(e)
}

func pair<T>(value: T, e: Extern<RT>): Array<T> {
    [value, value]
}

func callLambda<T>(f: () -> T, e: Extern<RT>): T {
    f()
}

func choose<T>(value: T, e: Extern<RT>): Int64 {
    1
}

func choose<T>(value: T, a: Any): Int64 {
    2
}

func runtimeOf<R>(e: Extern<R>, value: Int64): Int64 where R <: ForeignRuntime<R> {
    value
}

func check(name: String, ok: Bool, expectedConversions: Int64): Unit {
    if (!ok || conversions != expectedConversions) {
        throw Exception("${name}: conversions=${conversions}, expected ${expectedConversions}")
    }
    conversions = 0
}

main() {
    let s: String = keep("a", 2)
    check("keep", s == "a", 1)
    check("payload", payload(true, 7) == 7, 1)
    check("return type", pair(1.5, "b") == [1.5, 1.5], 1)
    check("lambda", callLambda({=> 5}, 3) == 5, 1)
    let e = RT.toExtern(4)
    conversions = 0
    check("Extern argument", keep(1, e) == 1, 0)
    check("overload", choose(1, 2) == 1, 1)
    check("overload explicit", choose<Int64>(1, 2) == 1, 1)
    check("Extern<R> argument", runtimeOf(e, 6) == 6, 0)
    0
}
