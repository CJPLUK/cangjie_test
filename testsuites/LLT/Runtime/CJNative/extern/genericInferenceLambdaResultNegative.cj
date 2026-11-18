// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 parameters of this lambda expression must have type annotations
// ASSERT: scan-1 1 error generated
// ASSERT: scan-not Assertion

// When the inference of a call fails, its lambda arguments are checked against their parameter types while the
// runtime R of Extern<R> is still unknown. A lambda result of type Extern<RT> is checked against Extern<R> without
// conversion, and only the usual error for the lambda is reported.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, arg: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { (Extern.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

func resultAndValues<R, T>(p: (Int64) -> Extern<R>, x: T, y: T): Int64 where R <: ForeignRuntime<R> { 1 }

main() {
    let e = Extern<RT>(0)
    resultAndValues({ i => e }, 1, "s")
    0
}
