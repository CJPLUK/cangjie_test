// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-9 unsafe function or native function should be invoked in unsafe context.

// The implicit calls to unsafe functions of a foreign runtime must be in an unsafe context, as the calls written
// explicitly. Each line of main is reported once, also when it calls several unsafe functions.

class RT <: ForeignRuntime<RT> {
    public unsafe static func toExtern<T>(value: T): Extern<RT> {
        Extern<RT>(value)
    }

    public unsafe static func memberAccess(e: Extern<RT>, name: String): Extern<RT> {
        e
    }

    public unsafe static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}

    public unsafe static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> {
        e
    }

    public unsafe static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}

    public unsafe static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        e
    }

    public static func fromExtern<T>(e: Extern<RT>): T {
        throw Exception()
    }
}

func take(e: Extern<RT>): Unit {}

main() {
    let e = unsafe { Extern<RT>(0) }
    let a: Extern<RT> = 1 // toExtern
    take(2)               // toExtern
    e.f                   // memberAccess
    e.f = 3               // memberUpdate
    e[0]                  // indexedAccess
    e[0] = 4              // indexedUpdate
    e(5)                  // functionCall
    e.f += 6              // memberAccess, functionCall and memberUpdate
    e[0] += 7             // indexedAccess, memberAccess, functionCall and indexedUpdate
    unsafe {
        e.g
    }
    0
}
