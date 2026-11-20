// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-4 error: implicit conversion to 'Extern' is not allowed in 'const' code
// ASSERT: scan-not Assertion

// The value of an empty block, or of a block ending with a declaration, is the unit value. In 'const' code that unit
// value is rejected where Extern<T> is expected, including a const function body and a const lambda body.

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
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

const func endsWithDecl(): Extern<DummyRT> {
    let x = 1
}

const func emptyBody(): Extern<DummyRT> {}

const func lambdaBodies(): Int64 {
    let ends: () -> Extern<DummyRT> = { => let y = 1 }
    let empty: () -> Extern<DummyRT> = { => }
    0
}

main() {
    0
}
