// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-5 error: implicit conversion to 'Extern' is not allowed in 'const' code
// ASSERT: scan-not dynamic operation on 'Extern'
// ASSERT: scan-not expected 'const'

// Implicit conversions to Extern<T> are rejected in 'const' code also for an 'if' with an 'else if' branch, a 'match'
// without a selector, or an 'if' with a branch that is empty or ends with a declaration, whose value is the unit value.
// When some branch is not of type Extern<T>, the expression is converted as a whole, and the error is reported on it.
// They are also rejected in the argument of a pipeline, which is desugared into a call.

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

const func takes(e: Extern<DummyRT>): Int64 {
    0
}

const func elseIfConversion(n: Int64, e: Extern<DummyRT>): Int64 {
    let x: Extern<DummyRT> = if (n < 0) {
        e
    } else if (n == 0) {
        1
    } else {
        e
    }
    0
}

const func noSelectorConversion(b: Bool, e: Extern<DummyRT>): Int64 {
    let x: Extern<DummyRT> = match {
        case b => 1
        case _ => e
    }
    0
}

const func pipelineConversion(): Int64 {
    1 |> takes
}

const func unitConversion(b: Bool, e: Extern<DummyRT>): Int64 {
    let x: Extern<DummyRT> = if (b) {
        let _ = 1
    } else {
        e
    }
    let y: Extern<DummyRT> = if (b) {
        e
    } else {}
    0
}

main() {
    0
}
