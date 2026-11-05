// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-15 error: implicit conversion to 'Extern' is not allowed in 'const' code
// ASSERT: scan-8 error: dynamic operation on 'Extern' is not allowed in 'const' code
// ASSERT: scan-not expected 'const'

// Implicit conversions to Extern<T> and dynamic operations on Extern<T> are desugared into calls to static functions
// of the foreign runtime, which are not 'const'. Each conversion and each operation is reported once.

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

// Implicit conversions.
const value: Extern<DummyRT> = 42

const func takes(e: Extern<DummyRT>): Int64 {
    0
}

const argument = takes(1)

const func letConversion(): Int64 {
    let a: Extern<DummyRT> = 1
    0
}

const func ifConversion(b: Bool): Int64 {
    let x: Extern<DummyRT> = if (b) { 1 } else { 2 }
    0
}

const func matchConversion(n: Int64): Int64 {
    let x: Extern<DummyRT> = match (n) {
        case 0 => 1
        case _ => 2
    }
    0
}

const func tryConversion(): Int64 {
    let x: Extern<DummyRT> = try { 1 } catch (_: Exception) { 2 }
    0
}

const func tupleConversion(): Int64 {
    let t: (Extern<DummyRT>, Int64) = (1, 2)
    0
}

const func bodyConversion(): Extern<DummyRT> {
    1
}

const func returnConversion(): Extern<DummyRT> {
    return 1
}

const func coalescingConversion(e: ?Extern<DummyRT>): Extern<DummyRT> {
    e ?? 1
}

const func defaultConversion(e!: Extern<DummyRT> = 1): Int64 {
    0
}

const func crossRuntimeConversion<A, B>(e: Extern<A>): Extern<B> where A <: ForeignRuntime<A>,
    B <: ForeignRuntime<B> {
    e
}

struct WithAssignment {
    let e: Extern<DummyRT>
    const init() {
        this.e = 1
    }
}

struct WithMemberInitializer {
    let e: Extern<DummyRT> = 1
    let n: Int64
    const init(n: Int64) {
        this.n = n
    }
}

func localConst(): Unit {
    const y: Extern<DummyRT> = 1
}

// Dynamic operations.
const func member(e: Extern<DummyRT>): Extern<DummyRT> {
    e.foo
}

const func call(e: Extern<DummyRT>): Extern<DummyRT> {
    e()
}

const func index(e: Extern<DummyRT>): Extern<DummyRT> {
    e[0]
}

const func genericMember<T>(e: Extern<T>): Extern<T> where T <: ForeignRuntime<T> {
    e.foo
}

const func memberUpdate(e: Extern<DummyRT>): Unit {
    e.foo = e
}

const func indexedUpdate(e: Extern<DummyRT>): Unit {
    e[0] = e
}

const func compoundUpdate(e: Extern<DummyRT>): Unit {
    e.foo += e
}

const func pipeline(e: Extern<DummyRT>): Extern<DummyRT> {
    1 |> e
}

main() {
    0
}
