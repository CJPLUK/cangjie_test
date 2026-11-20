// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The unsafe toExtern function of the runtime may be called wherever Extern<T> is expected within an unsafe block or an
// unsafe function.

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

    public unsafe static func toExtern<R>(value: R): Extern<RT> {
        conversions++
        Extern<RT>(value)
    }
}

class Both {
    let values = [10, 20]
    operator func [](index: Extern<RT>): Int64 {
        values[RT.fromExtern<Int64>(index)]
    }
    operator func [](index: Extern<RT>, value!: Int64): Unit {
        values[RT.fromExtern<Int64>(index)] = value
    }
}

unsafe func body(): Extern<RT> {
    1
}

unsafe func returned(): Extern<RT> {
    return 2
}

func lambdaResult(): () -> Extern<RT> {
    unsafe { { => 3 } }
}

func argument(e: Extern<RT>): Extern<RT> {
    e
}

func check(name: String, e: Extern<RT>, expected: Int64, expectedConversions: Int64): Unit {
    if (RT.fromExtern<Int64>(e) != expected || conversions != expectedConversions) {
        throw Exception("${name}: conversions=${conversions}, expected ${expectedConversions}")
    }
    conversions = 0
}

main() {
    let initialized: Extern<RT> = unsafe { RT.toExtern(0) }
    check("explicit conversion", initialized, 0, 1)
    unsafe {
        let declared: Extern<RT> = 1
        check("initializer", declared, 1, 1)
        check("function body", body(), 1, 1)
        check("return", returned(), 2, 1)
        check("lambda body", lambdaResult()(), 3, 1)
        var assigned = initialized
        assigned = 4
        check("assignment", assigned, 4, 1)
        check("argument", argument(5), 5, 1)
        let block: Extern<RT> = unsafe { 6 }
        check("unsafe block", block, 6, 1)
        let parenthesized: Extern<RT> = (unsafe { 7 })
        check("parenthesized unsafe block", parenthesized, 7, 1)
        let branch: Extern<RT> = if (initialized is Extern<RT>) { 8 } else { 0 }
        check("if", branch, 8, 1)
        let elements: Array<Extern<RT>> = [9, 10]
        check("array elements", elements[1], 10, 2)
        let tuple: (Extern<RT>, Int64) = (11, 0)
        check("tuple element", tuple[0], 11, 1)
        let b = Both()
        b[0] += 1
        b[(unsafe { 1 })]++
        if (b.values != [11, 21] || conversions != 4) {
            throw Exception("shared index: values=${b.values}, conversions=${conversions}")
        }
        conversions = 0
    }
    let noConversion: Extern<RT> = unsafe { initialized }
    check("Extern value", noConversion, 0, 0)
    0
}
