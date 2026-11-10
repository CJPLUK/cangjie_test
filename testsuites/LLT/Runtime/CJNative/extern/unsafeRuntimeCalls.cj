// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The implicit calls to unsafe functions of a foreign runtime are allowed in an unsafe context: an unsafe block, an
// unsafe function or a lambda in an unsafe block. For a generic runtime, the calls are to the functions of
// ForeignRuntime<T>, which are not unsafe.

var calls = 0

class RT <: ForeignRuntime<RT> {
    public unsafe static func toExtern<T>(value: T): Extern<RT> {
        calls++
        Extern<RT>(value)
    }

    public unsafe static func memberAccess(e: Extern<RT>, name: String): Extern<RT> {
        calls++
        e
    }

    public unsafe static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {
        calls++
    }

    public unsafe static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> {
        calls++
        e
    }

    public unsafe static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {
        calls++
    }

    public unsafe static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        calls++
        e
    }

    public static func fromExtern<T>(e: Extern<RT>): T {
        (Extern<RT>.getPayload(e) as T).getOrThrow()
    }
}

func take(e: Extern<RT>): Unit {}

unsafe func inUnsafeFunc(): Extern<RT> {
    let e: Extern<RT> = 1 // toExtern
    e.field               // memberAccess
}

func inGeneric<T>(e: Extern<T>): Extern<T> where T <: ForeignRuntime<T> {
    let x: Extern<T> = 2 // toExtern
    x.field              // memberAccess
}

func check(name: String, expected: Int64): Unit {
    if (calls != expected) {
        throw Exception("${name}: calls=${calls}, expected ${expected}")
    }
    calls = 0
}

main() {
    let e = unsafe { Extern<RT>(0) }
    unsafe {
        let a: Extern<RT> = 1
        check("conversion", 1)
        take(2)
        check("argument", 1)
        e.f
        check("member access", 1)
        e.f = 3
        check("member update", 1)
        e[0]
        check("indexed access", 1)
        e[0] = 4
        check("indexed update", 1)
        e(5)
        check("function call", 1)
        e.f += 6
        // memberAccess twice, functionCall, memberUpdate
        check("member compound", 4)
        e[0] += 7
        // indexedAccess, memberAccess, functionCall, indexedUpdate
        check("indexed compound", 4)
        let lambda = { => let b: Extern<RT> = 8; b.g }
        lambda()
        check("lambda", 2)
    }
    unsafe { inUnsafeFunc() }
    check("unsafe function", 2)
    inGeneric<RT>(e)
    check("generic runtime", 2)
    0
}
