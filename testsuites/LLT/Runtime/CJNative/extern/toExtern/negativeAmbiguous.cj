// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan ambiguous match for function call 'amb'

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

public class OtherRT <: ForeignRuntime<OtherRT> {
    public static func memberAccess(e: Extern<OtherRT>, field: String): Extern<OtherRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<OtherRT>, arg: Any): Extern<OtherRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<OtherRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<OtherRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<OtherRT>, args: Array<Any>): Extern<OtherRT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<OtherRT>): R {
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<OtherRT> {
        Extern<OtherRT>(v)
    }
}

func amb(_: Extern<DummyRT>): Int64 {
    1
}

func amb(_: Extern<OtherRT>): Int64 {
    2
}

main() {
    amb(42)
    0
}
