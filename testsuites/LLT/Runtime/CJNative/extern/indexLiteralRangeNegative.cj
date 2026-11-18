// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-2 the number '0x8000000000000000' exceeds the value range of type 'Int64'
// ASSERT: scan-1 2 errors generated
// ASSERT: scan-not Assertion

// An integer literal index of a dynamic index access or update has type Int64, so a literal out of its range is
// reported.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, arg: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { (Extern.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

main() {
    let e = Extern<RT>(0)
    let read = e[0x8000000000000000]
    e[0x8000000000000000] = 1
    0
}
