// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A runtime type need not declare the `ForeignRuntime` operations itself: it may inherit
// them, here from the default implementations of an interface that extends
// `ForeignRuntime<T>`, either directly (`IfaceRT`) or through a superclass (`SuperRT`).
// Every `Extern<T>` operation must desugar to the inherited implementation and dispatch to
// it, matching what a hand-written `T.memberAccess(e, "f")` does. This is the regression
// guard for the desugaring resolving the runtime function against only the members `T`
// declares itself, which used to abort the compiler and later rejected these programs as
// having an unimplemented static function.

var trace: String = ""

func anyToString(v: Any): String {
    match (v) {
        case i: Int64 => i.toString()
        case s: String => s
        case _ => "?"
    }
}

interface DefaultOps<T> <: ForeignRuntime<T> where T <: ForeignRuntime<T> {
    static func memberAccess(e: Extern<T>, field: String): Extern<T> {
        trace += "memberAccess:" + field + ";"
        return e
    }
    static func indexedAccess(e: Extern<T>, arg: Any): Extern<T> {
        trace += "indexedAccess:" + anyToString(arg) + ";"
        return e
    }
    static func memberUpdate(_: Extern<T>, field: String, value: Any): Unit {
        trace += "memberUpdate:" + field + "=" + anyToString(value) + ";"
    }
    static func indexedUpdate(_: Extern<T>, field: Any, value: Any): Unit {
        trace += "indexedUpdate:" + anyToString(field) + "=" + anyToString(value) + ";"
    }
    static func functionCall(e: Extern<T>, args: Array<Any>): Extern<T> {
        trace += "functionCall:" + args.size.toString() + ";"
        return e
    }
    static func fromExtern<R>(h: Extern<T>): R {
        trace += "fromExtern;"
        return (Extern<T>.getPayload(h) as R).getOrThrow()
    }
    static func toExtern<R>(v: R): Extern<T> {
        trace += "toExtern;"
        return Extern<T>(v)
    }
}

// Implementations inherited directly from the interface default implementations.
class IfaceRT <: DefaultOps<IfaceRT> {}

// Implementations inherited through a superclass, one level further away.
open class BaseRT<T> <: DefaultOps<T> where T <: ForeignRuntime<T> {}
class SuperRT <: BaseRT<SuperRT> {}

const EXPECTED = "toExtern;memberAccess:foo;memberUpdate:bar=7;indexedAccess:3;indexedUpdate:4=5;functionCall:2;fromExtern;"

func check(actual: String, expected: String, what: String): Unit {
    if (actual != expected) {
        throw Exception(what + ": expected '" + expected + "' but got '" + actual + "'")
    }
}

main() {
    trace = ""
    let e1: Extern<IfaceRT> = 42
    let _ = e1.foo
    e1.bar = 7
    let _ = e1[3]
    e1[4] = 5
    let _ = e1(1, 2)
    let back1 = (Int64)e1
    check(trace, EXPECTED, "interface default implementations")
    if (back1 != 42) {
        throw Exception("fromExtern via interface default returned " + back1.toString())
    }

    trace = ""
    let e2: Extern<SuperRT> = 42
    let _ = e2.foo
    e2.bar = 7
    let _ = e2[3]
    e2[4] = 5
    let _ = e2(1, 2)
    let back2 = (Int64)e2
    check(trace, EXPECTED, "implementations inherited through a superclass")
    if (back2 != 42) {
        throw Exception("fromExtern via superclass returned " + back2.toString())
    }
    0
}
