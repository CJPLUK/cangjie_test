// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot convert an integer literal to type 'Enum-Option<Enum-Extern<Class-DummyRT>>'
// ASSERT: scan unable to infer generic argument of this function
// ASSERT: scan expected 'Struct-Array<Enum-Extern<Class-DummyRT>>', found 'Struct-Array<Int64>'
// ASSERT: scan expected '() -> Enum-Extern<Class-DummyRT>', found '() -> Int64'
// ASSERT: scan expected 'Enum-Extern<Class-DummyRT>', found 'Int64'
// ASSERT: scan inconsistent element type for array literal
// ASSERT: scan 6 errors generated

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

func g(): Int64 {
    1
}

main() {
    // A type that only contains Extern<T> doesn't allow the conversion.
    let opt: ?Extern<DummyRT> = 1
    let ints: Array<Int64> = [3]
    let arr: Array<Extern<DummyRT>> = ints
    let fn: () -> Extern<DummyRT> = g

    // The expected type of the argument of Some is still being inferred.
    let some: ?Extern<DummyRT> = Some(2)

    // A constant pattern is not converted.
    let e: Extern<DummyRT> = 4
    match (e) {
        case 5 => ()
        case _ => ()
    }

    // A subscripted literal has no expected type.
    var v: Extern<DummyRT> = 6
    v = [7, "a"][0]
}
