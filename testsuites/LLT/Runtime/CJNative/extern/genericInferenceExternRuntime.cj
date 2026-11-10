// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The runtime R of a parameter of type Extern<R> is inferred from the arguments of type Extern<T>. Any other argument
// for such a parameter is converted with the inferred runtime, so the call and its overload resolution are the same as
// with explicit type arguments.

var conversions = 0
var conversions2 = 0

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

class RT2 <: ForeignRuntime<RT2> {
    public static func memberAccess(e: Extern<RT2>, name: String): Extern<RT2> { throw Exception() }
    public static func indexedAccess(e: Extern<RT2>, index: Any): Extern<RT2> { throw Exception() }
    public static func memberUpdate(e: Extern<RT2>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT2>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT2>, args: Array<Any>): Extern<RT2> { throw Exception() }

    public static func fromExtern<R>(e: Extern<RT2>): R {
        (Extern<RT2>.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(value: R): Extern<RT2> {
        conversions2++
        Extern<RT2>(value)
    }
}

func forward<R>(e: Extern<R>, value: Extern<R>): Extern<R> where R <: ForeignRuntime<R> {
    value
}

func first<R>(value: Extern<R>, e: Extern<R>): Extern<R> where R <: ForeignRuntime<R> {
    value
}

func choose<R>(e: Extern<R>, value: Extern<R>): Int64 where R <: ForeignRuntime<R> {
    1
}

func choose<R>(e: Extern<R>, value: Any): Int64 where R <: ForeignRuntime<R> {
    2
}

func relay<R>(e: Extern<R>): Extern<R> where R <: ForeignRuntime<R> {
    forward(e, 5)
}

func check(name: String, ok: Bool, expectedConversions: Int64, expectedConversions2: Int64): Unit {
    if (!ok || conversions != expectedConversions || conversions2 != expectedConversions2) {
        throw Exception(
            "${name}: conversions=${conversions}/${conversions2}, expected ${expectedConversions}/${expectedConversions2}")
    }
    conversions = 0
    conversions2 = 0
}

main() {
    let e = Extern<RT>(0)
    let e2 = Extern<RT2>(0)
    check("explicit runtime", RT.fromExtern<Int64>(forward<RT>(e, 42)) == 42, 1, 0)
    check("from first argument", RT.fromExtern<Int64>(forward(e, 42)) == 42, 1, 0)
    check("from second argument", RT.fromExtern<String>(first("a", e)) == "a", 1, 0)
    check("Extern argument", RT.fromExtern<Int64>(forward(e, e)) == 0, 0, 0)
    check("other runtime", RT2.fromExtern<Int64>(forward(e2, 7)) == 7, 0, 1)
    check("whole literal", RT.fromExtern<Array<Int64>>(forward(e, [1, 2])) == [1, 2], 1, 0)
    check("overload", choose(e, 3) == 1, 1, 0)
    check("overload explicit", choose<RT>(e, 3) == 1, 1, 0)
    check("generic caller", RT2.fromExtern<Int64>(relay(e2)) == 5, 0, 1)
    0
}
