// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Shapes that stay on the ordinary (non-forced-cast) path: a parenthesized
// function call `(foo)(x)` (including when the argument is Extern), a
// parenthesized expression `(a + b)`, and canonical constructor calls `Type(args)`.
// A parenthesized type `(Type)(args)` always selects forced-cast semantics and is
// rejected when its operand is not Extern; 11_negativeFallbackCallRejected pins it.

class DummyRuntime <: ForeignRuntime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexedAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (Extern<DummyRuntime>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

func inc(x: Int64): Int64 { x + 1 }

func externArity(x: Extern<DummyRuntime>): Int64 { 42 }

func makeExtern(): Extern<DummyRuntime> { Extern<DummyRuntime>(0) }

class Bar {
    let v: Int64
    public init(v: Int64) { this.v = v }
    public init(a: Int64, b: Int64) { this.v = a + b }
}

main() {
    // (foo)(x): foo is a function -> ordinary call.
    let call = (inc)(1)
    // (foo)(externArg): still an ordinary call even though the arg is Extern.
    let callExtern = (externArity)(makeExtern())
    // (a + b): parenthesized expression, not a forced-cast candidate.
    let a: Int64 = 10
    let b: Int64 = 20
    let parenExpr = (a + b)
    // Constructors use the unambiguous `Type(args)` spelling.
    let ctorSingle: Bar = Bar(1)
    let ctorMulti: Bar = Bar(2, 3)

    if (call != 2 || callExtern != 42 || parenExpr != 30 ||
        ctorSingle.v != 1 || ctorMulti.v != 5) {
        throw Exception("fallback interpretation failed")
    }
}
