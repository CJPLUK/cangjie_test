// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A parameter type mixing Extern<T> and type variables accepts a literal whose type is a subtype of it, such as an
// array literal for a Collection or an Iterable, or a tuple literal for an option type. The parts matching Extern<T>
// are converted and the other parts determine the type arguments, as with explicit type arguments.

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

func choose<T>(value: T, pairs: Collection<(Extern<RT>, T)>): Int64 {
    1
}

func choose<T>(value: T, pairs: Any): Int64 {
    2
}

func firstOf<T>(pairs: Iterable<(Extern<RT>, T)>): ?T {
    for (pair in pairs) {
        return pair[1]
    }
    None
}

func nested<T>(rows: Collection<Array<(T, Extern<RT>)>>): T {
    var result: ?T = None
    for (row in rows) {
        result = row[0][0]
        break
    }
    result.getOrThrow()
}

func optional<T>(value: T, pair: ?(Extern<RT>, T)): Int64 {
    1
}

func optional<T>(value: T, pair: Any): Int64 {
    2
}

func sizeWith<R>(e: Extern<R>, values: Collection<Extern<R>>): Int64 where R <: ForeignRuntime<R> {
    values.size
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
    let e2 = Extern<RT2>(0)
    check("collection overload", choose(0, [(1, 2)]) == 1, 1, 0)
    check("collection overload explicit", choose<Int64>(0, [(1, 2)]) == 1, 1, 0)
    check("iterable", firstOf([(1, "a"), (2, "b")]) == "a", 2, 0)
    check("nested collection", nested([[("a", 1)], [("b", 2)]]) == "a", 2, 0)
    check("option overload", optional(0, (1, 2)) == 1, 1, 0)
    check("option overload explicit", optional<Int64>(0, (1, 2)) == 1, 1, 0)
    check("runtime from other argument", sizeWith(e2, [1, "a", true]) == 3, 0, 3)
    0
}
