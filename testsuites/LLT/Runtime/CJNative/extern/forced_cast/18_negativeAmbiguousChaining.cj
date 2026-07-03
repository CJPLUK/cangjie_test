// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan mismatched types
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'Extern' type
// ASSERT: scan use 'as' for ordinary type conversions
// ASSERT: scan expected member name or constructor call after 'Foo' type name

// Negative: ill-formed chained parenthesized forms must produce a CLEAN diagnostic,
// never an ICE. `(X)(Y)(Z)` parses left-associatively as `((X)(Y))(Z)`, so a
// double-cast / nested-ambiguous chain type-checks the inner grouping first and
// fails there — exactly as stock Cangjie does. This is the regression guard for the
// former crash where a right-associative speculative parse left the inner
// `AmbiguousForcedCastExpr` un-desugared, and its invalid speculative `RefType`
// survived into the checked AST and tripped `ASTTypeValidator` (an ICE in debug, a
// silently-invalid node in release). Every case below is now a normal type error.
//
// Note on the primitive-type core `(Int64)(Int64)(ext(5))`: under left association
// the middle `(Int64)` is a value operand, but a primitive-type keyword cannot be
// an expression, so it is rejected at PARSE time ("expected expression after '(',
// found keyword 'Int64'"). A parse error halts the rest of the file, so that form
// cannot be combined with the sema cases here; the class-typed `(Foo)(Foo)(ext(5))`
// below exercises the same double-cast shape while still reaching type checking.

class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> { return e }
    public static func indexAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> { return e }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> { return e }
    public static func fromExtern<R>(h: Extern<DummyRT>): R { return (Extern<DummyRT>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRT> { return Extern<DummyRT>(v) }
}

func ext(v: Int64): Extern<DummyRT> { return Extern<DummyRT>(v) }
func foo(x: Int64): Int64 { return x }
func bar(x: Int64): Int64 { return x }

class Foo { init(x: Int64) {} }

main() {
    // Nested value-form chains: both callees are functions, so `((foo)(foo))(1)`
    // passes a function where an Int64 is expected -> mismatched types (no ICE).
    let a = (foo)(foo)(1)
    let b = (foo)(bar)(1)
    // Depth 3 exercises the recursive left-folding of the same shape.
    let c = (foo)(foo)(foo)(1)
    // Double cast, nested via explicit parens: the inner `(Int64)(ext(5))` yields a
    // non-Extern Int64, so the outer forced cast has an invalid operand.
    let d = (Int64)((Int64)(ext(5)))
    // Double cast, class targets: `((Foo)(Foo))(ext(5))` fails on the inner grouping.
    let e = (Foo)(Foo)(ext(5))

    // Deep and irregular nesting: the same ill-formed shapes wrapped in extra layers
    // must still produce clean type errors, never an ICE — the fix is shallow-safe, so a
    // former-crash chain does not resurface no matter how it is nested.
    let f = (foo)((foo)(foo)(1))              // inner former-ICE chain, wrapped in a call
    let g = (Int64)((foo)(foo)(1))            // wrapped in a forced cast
    let h = (foo)((foo)((foo)(foo)(1)))       // former-ICE chain nested two layers deep
    let i = ((foo)(foo))((foo)(foo))          // two ambiguous groups juxtaposed
    let j = (Int64)((Int64)((Int64)(ext(5)))) // three explicitly nested double casts
}
