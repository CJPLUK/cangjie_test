// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Generics in forced casts: a generic target type `(Box<Int64>)e`, and a forced
// cast whose Extern runtime argument is itself a generic type parameter (the cast
// must still desugar through Runtime.fromExtern instantiated with that parameter).

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class Box<T> {
    let value: T
    public init(value: T) { this.value = value }
}

class Foo {
    let value: Int64
    public init(value: Int64) { this.value = value }
}

func makeBoxExtern(v: Int64): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(Box<Int64>(v))
}

// Generic Extern runtime parameter: forced cast inside a function generic over T.
func genericBare<T>(): Int64 where T <: Runtime<T> {
    let e = Extern<T>(42)
    (Int64)e
}

func genericReturn<T>(): Int64 where T <: Runtime<T> {
    let e = Extern<T>(43)
    return (Int64)e
}

func genericLocal<T>(): Int64 where T <: Runtime<T> {
    let e = Extern<T>(44)
    let value: Int64 = (Int64)e
    value
}

func genericClass<T>(): Foo where T <: Runtime<T> {
    let e = Extern<T>(Foo(45))
    (Foo)e
}

func genericNested<T>(): Array<Int64> where T <: Runtime<T> {
    let e = Extern<T>([46, 47])
    (Array<Int64>)e
}

main() {
    // Generic target type.
    let box: Box<Int64> = (Box<Int64>)makeBoxExtern(99)

    // Generic runtime parameter.
    let foo = genericClass<DummyRuntime>()
    let values = genericNested<DummyRuntime>()

    if (box.value != 99 ||
        genericBare<DummyRuntime>() != 42 || genericReturn<DummyRuntime>() != 43 ||
        genericLocal<DummyRuntime>() != 44 || foo.value != 45 ||
        values[0] != 46 || values[1] != 47) {
        throw Exception("generic forced cast failed")
    }
}
