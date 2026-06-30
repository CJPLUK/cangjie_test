// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The simplest forced casts: a bare operand `(T)e`, a parenthesized operand
// `(T)(e)`, and primitive value round trips through the Extern payload. All
// resolve to `Runtime.fromExtern`.

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class Foo {
    let id: Int64
    public init(id: Int64) { this.id = id }
}

func makeFooExtern(id: Int64): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(Foo(id))
}

main() {
    // Bare operand: (T)e
    let bare: Foo = (Foo)makeFooExtern(1)
    // Parenthesized operand: (T)(e)
    let paren: Foo = (Foo)(makeFooExtern(2))

    // Primitive round trips.
    let i8: Int8 = 8
    let i16: Int16 = 16
    let i32: Int32 = 32
    let i64: Int64 = 64
    let u8: UInt8 = 8
    let u16: UInt16 = 16
    let u32: UInt32 = 32
    let u64: UInt64 = 64
    let f32: Float32 = 3.25
    let f64: Float64 = 6.5
    let b: Bool = true
    let s: String = "extern"

    let roundI8: Int8 = (Int8)Extern<DummyRuntime>(i8)
    let roundI16: Int16 = (Int16)Extern<DummyRuntime>(i16)
    let roundI32: Int32 = (Int32)Extern<DummyRuntime>(i32)
    let roundI64: Int64 = (Int64)Extern<DummyRuntime>(i64)
    let roundU8: UInt8 = (UInt8)Extern<DummyRuntime>(u8)
    let roundU16: UInt16 = (UInt16)Extern<DummyRuntime>(u16)
    let roundU32: UInt32 = (UInt32)Extern<DummyRuntime>(u32)
    let roundU64: UInt64 = (UInt64)Extern<DummyRuntime>(u64)
    let roundF32: Float32 = (Float32)Extern<DummyRuntime>(f32)
    let roundF64: Float64 = (Float64)Extern<DummyRuntime>(f64)
    let roundBool: Bool = (Bool)Extern<DummyRuntime>(b)
    let roundString: String = (String)Extern<DummyRuntime>(s)

    if (bare.id != 1 || paren.id != 2 ||
        roundI8 != i8 || roundI16 != i16 || roundI32 != i32 || roundI64 != i64 ||
        roundU8 != u8 || roundU16 != u16 || roundU32 != u32 || roundU64 != u64 ||
        roundF32 != f32 || roundF64 != f64 || roundBool != b || roundString != s) {
        throw Exception("basic forced cast failed")
    }
}
