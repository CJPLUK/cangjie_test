// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Shapes that look like a forced cast but must stay on the ordinary
// (non-forced-cast) path: a parenthesized function call `(foo)(x)` (including
// when the argument is Extern), a parenthesized expression `(a + b)`, and a
// `(Type)(args)` whose operand is not Extern -- the forced-cast candidate is
// rejected and it falls back to an ordinary constructor call (single- and
// multi-argument). The positive forced-cast counterpart of this fallback is the
// rejected case in 11_negativeFallbackCallRejected, where no constructor matches.

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
    // (Type)(args): Bar is a type, so this is a forced-cast candidate, but the
    // operand is not Extern, so the candidate is rejected and it falls back to an
    // ordinary constructor call -- both single- and multi-argument.
    let ctorSingle: Bar = (Bar)(1)
    let ctorMulti: Bar = (Bar)(2, 3)

    if (call != 2 || callExtern != 42 || parenExpr != 30 ||
        ctorSingle.v != 1 || ctorMulti.v != 5) {
        throw Exception("fallback interpretation failed")
    }
}
