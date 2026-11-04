// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-3 unsafe function or native function should be invoked in unsafe context.
// ASSERT: scan-not Assertion

// The value of an unsafe block is converted within that block, but a value produced outside any unsafe block is
// still converted outside it, so the unsafe toExtern function of the runtime cannot be called. Each conversion
// outside an unsafe block is reported once.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public unsafe static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

main() {
    let c = true
    let a: Extern<RT> = unsafe { 1 }                                // OK, converted within the unsafe block.
    let b: Extern<RT> = if (c) { unsafe { 2 } } else { 3 }          // Only 3 is converted outside an unsafe block.
    let d: Array<Extern<RT>> = [unsafe { 4 }, 5]                    // Only 5 is converted outside an unsafe block.
    let e: Extern<RT> = 6                                           // Converted outside an unsafe block.
    0
}
