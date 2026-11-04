// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A concrete parameter type containing Extern<RT> accepts a literal whose elements are converted. Such a parameter
// does not constrain the type arguments inferred for a generic call, so the call and its overload resolution are the
// same as with explicit type arguments, whatever kind of call it is and wherever the type arguments come from.

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

func choose<T>(value: T, a: Array<Extern<RT>>): Int64 {
    1
}

func choose<T>(value: T, a: Any): Int64 {
    2
}

func nested<T>(value: T, a: Array<Array<Extern<RT>>>): Int64 {
    1
}

func nested<T>(value: T, a: Any): Int64 {
    2
}

func fromReturn<T>(a: Array<Extern<RT>>, n: Int64): Array<T> {
    Array<T>()
}

func named<T>(value: T, a!: Array<Extern<RT>> = []): Int64 {
    a.size
}

class C {
    func choose<T>(value: T, a: Array<Extern<RT>>): Int64 {
        1
    }

    func choose<T>(value: T, a: Any): Int64 {
        2
    }
}

class G<T> {
    let size: Int64

    init(value: T, a: Array<Extern<RT>>) {
        size = a.size
    }
}

func check(name: String, ok: Bool, expectedConversions: Int64): Unit {
    if (!ok || conversions != expectedConversions) {
        throw Exception("${name}: conversions=${conversions}, expected ${expectedConversions}")
    }
    conversions = 0
}

main() {
    check("overload", choose(0, [1, 2]) == 1, 2)
    check("overload explicit", choose<Int64>(0, [1, 2]) == 1, 2)
    check("nested literal", nested(0, [[1], ["s"]]) == 1, 2)
    let fromTarget: Array<Int64> = fromReturn([1, "s"], 0)
    check("return target", fromTarget.size == 0, 2)
    check("named argument", named(0, a: [1, 2, 3]) == 3, 3)
    check("member function", C().choose(0, [1, 2]) == 1, 2)
    check("constructor", G(0, [1, 2]).size == 2, 2)
    0
}
