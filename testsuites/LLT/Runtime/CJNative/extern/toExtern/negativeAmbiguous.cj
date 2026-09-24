// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan ambiguous match for function call 'amb'

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>.ExternPayload(v)
    }
}

public class OtherRT <: ForeignRuntime<OtherRT> {
    public static func eval(t: Extern<OtherRT>): Extern<OtherRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<OtherRT>): R {
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<OtherRT> {
        Extern<OtherRT>.ExternPayload(v)
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
