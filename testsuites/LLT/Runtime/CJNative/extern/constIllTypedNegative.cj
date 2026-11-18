// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 undeclared identifier 'undefinedName'
// ASSERT: scan-1 no matching function for operator '()' function call
// ASSERT: scan-1 2 errors generated
// ASSERT: scan-not 'const' code
// ASSERT: scan-not Assertion

// An ill-typed tuple literal or call in 'const' code is reported as usual. The checks for implicit conversions to
// Extern<T> in 'const' code skip it, so they report nothing more.

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

const func illTypedTuple(): Int64 {
    let t: (Extern<DummyRT>, Int64) = (undefinedName, 1)
    0
}

const func illTypedCall(): Int64 {
    let x = 1
    x(2)
}

main() {
    0
}
