// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A block is never converted as a whole, only its value is. So the value of an unsafe block is converted within that
// block, where the unsafe toExtern function of the runtime may be called, wherever Extern<T> is expected.

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

func body(): Extern<RT> {
    unsafe { 1 }
}

func returned(): Extern<RT> {
    return unsafe { 2 }
}

func lambdaResult(): () -> Extern<RT> {
    { => unsafe { 3 } }
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
    let initialized: Extern<RT> = unsafe { 0 }
    check("initializer", initialized, 0, 1)
    check("function body", body(), 1, 1)
    check("return", returned(), 2, 1)
    check("lambda body", lambdaResult()(), 3, 1)
    var assigned = initialized
    assigned = unsafe { 4 }
    check("assignment", assigned, 4, 1)
    check("argument", argument(unsafe { 5 }), 5, 1)
    let nested: Extern<RT> = unsafe { unsafe { 6 } }
    check("nested unsafe blocks", nested, 6, 1)
    let branch: Extern<RT> = unsafe { if (initialized is Extern<RT>) { 7 } else { 0 } }
    check("branch in unsafe block", branch, 7, 1)
    let statements: Extern<RT> = unsafe {
        let x = 4
        x * 2
    }
    check("statements before the value", statements, 8, 1)
    let elements: Array<Extern<RT>> = [unsafe { 9 }, unsafe { 10 }]
    check("array elements", elements[1], 10, 2)
    let tuple: (Extern<RT>, Int64) = (unsafe { 11 }, 0)
    check("tuple element", tuple[0], 11, 1)
    let noConversion: Extern<RT> = unsafe { initialized }
    check("Extern value", noConversion, 0, 0)
    0
}
