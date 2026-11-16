// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 global/static variable 'late' is used before initialization
// ASSERT: scan-1 1 error generated
// ASSERT: scan-not Assertion

// An initialization error unrelated to Extern, in a package with Extern operations, is reported once.

let early = readLate()
let late = 1

func readLate() {
    late
}

let converted: Extern<RT> = 1
let accessed = converted.f

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<T>(e: Extern<RT>): T { throw Exception() }
    public static func toExtern<T>(value: T): Extern<RT> { Extern<RT>(value) }
}

main() {
    0
}
