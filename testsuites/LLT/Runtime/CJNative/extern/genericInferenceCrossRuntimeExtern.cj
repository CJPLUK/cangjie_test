// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A parameter of type Extern<RT> accepts a value of type Extern<RT2>, which is converted. It does not constrain the
// type arguments inferred for a generic call, so the call and its overload resolution are the same as with explicit
// type arguments.

var conversions = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }

    public static func toExtern<R>(value: R): Extern<RT> {
        conversions++
        Extern<RT>(value)
    }
}

class RT2 <: ForeignRuntime<RT2> {
    public static func memberAccess(e: Extern<RT2>, name: String): Extern<RT2> { e }
    public static func indexedAccess(e: Extern<RT2>, index: Any): Extern<RT2> { e }
    public static func memberUpdate(e: Extern<RT2>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT2>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT2>, args: Array<Any>): Extern<RT2> { e }
    public static func fromExtern<R>(e: Extern<RT2>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT2> { Extern<RT2>(value) }
}

func take<T>(x: T, e: Extern<RT>): T {
    x
}

func choose<T>(x: T, e: Extern<RT>): Int64 {
    1
}

func choose<T>(x: T, e: Any): Int64 {
    2
}

func check(name: String, ok: Bool, expectedConversions: Int64): Unit {
    if (!ok || conversions != expectedConversions) {
        throw Exception("${name}: conversions=${conversions}, expected ${expectedConversions}")
    }
    conversions = 0
}

main() {
    let other = Extern<RT2>(0)
    check("inferred", take(42, other) == 42, 1)
    check("explicit", take<Int64>(42, other) == 42, 1)
    check("overload", choose(42, other) == 1, 1)
    check("overload explicit", choose<Int64>(42, other) == 1, 1)
    0
}
