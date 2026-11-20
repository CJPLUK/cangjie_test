// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-8 unsafe function or native function should be invoked in unsafe context.
// ASSERT: scan-not Assertion

// The unsafe toExtern function of the runtime cannot be called outside an unsafe block or an unsafe function, also when
// the converted expression is itself an unsafe block. Each conversion outside an unsafe context is reported once.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public unsafe static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

func body(): Extern<RT> {
    unsafe { 1 }                                                    // The unsafe block is converted.
}

func argument(e: Extern<RT>): Extern<RT> {
    e
}

main() {
    let c = true
    let a: Extern<RT> = unsafe { 2 }                                // The unsafe block is converted.
    let p: Extern<RT> = (unsafe { 3 })                              // The parenthesized expression is converted.
    let b: Extern<RT> = if (c) { unsafe { 4 } } else { 5 }          // The if is converted.
    let d: Array<Extern<RT>> = [unsafe { 6 }, 7]                    // Each element is converted.
    let e = argument(unsafe { 8 })                                  // The unsafe block is converted.
    let f: Extern<RT> = 9                                           // 9 is converted.
    0
}
