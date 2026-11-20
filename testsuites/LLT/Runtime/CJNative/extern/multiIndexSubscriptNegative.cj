// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-7 a dynamic subscript of 'Extern' takes a single index
// ASSERT: scan-not expected 'integer type'
// ASSERT: scan-1 7 errors generated
// ASSERT: scan-not Assertion

// The foreign runtime receives one index at a time, so a dynamic subscript of a value of type Extern<T> takes a single
// index, whether it is read, updated, compound-assigned, incremented or decremented. A chain of subscripts and a tuple
// index are accepted.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

func generic<T>(e: Extern<T>): Extern<T> where T <: ForeignRuntime<T> {
    e[0, 1]
}

main() {
    let e = Extern<RT>(0)
    let read = e[0, "k"]
    e[0, 1, 2] = 3
    e[0, 1] += 2
    e[0, 1]++
    e[0, 1]--
    e.f[0, 1].g = 1
    let chained = e[0]["k"]
    e[0][1] = 3
    e[0][1] += 2
    let tuple = e[(0, "k")]
    e[(0, 1)] = 3
    0
}
