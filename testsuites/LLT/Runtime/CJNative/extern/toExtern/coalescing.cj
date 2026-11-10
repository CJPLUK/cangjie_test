// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// In o ?? v with o: ?Extern<T>, v is checked against Extern<T> and converted on its own, only when o is None. The
// desugared match (o) { case Some(x) => x case _ => v } is the only match whose cases are converted.

import std.collection.*

public class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> {
        accesses.add(field)
        e
    }
    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> {
        accesses.add("[]")
        e
    }
    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {
        accesses.add(field + "=")
    }
    public static func indexedUpdate(e: Extern<RT>, field: Any, value: Any): Unit {
        accesses.add("[]=")
    }
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        accesses.add("()")
        e
    }
    public static func fromExtern<R>(e: Extern<RT>): R {
        (Extern<RT>.getPayload(e) as R).getOrThrow()
    }
    public static func toExtern<R>(v: R): Extern<RT> {
        let kind = match (v) {
            case _: Int64 => "Int64"
            case _: String => "String"
            case _: Bool => "Bool"
            case _: Unit => "Unit"
            case _: Extern<RT2> => "Extern<RT2>"
            case _: Option<String> => "Option<String>"
            case _: Option<Int64> => "Option<Int64>"
            case _ => "other"
        }
        converted.add(kind)
        Extern<RT>(v)
    }
    public static let converted = ArrayList<String>()
    public static let accesses = ArrayList<String>()
}

public class RT2 <: ForeignRuntime<RT2> {
    public static func memberAccess(e: Extern<RT2>, field: String): Extern<RT2> { e }
    public static func indexedAccess(e: Extern<RT2>, arg: Any): Extern<RT2> { e }
    public static func memberUpdate(e: Extern<RT2>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT2>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT2>, args: Array<Any>): Extern<RT2> { e }
    public static func fromExtern<R>(e: Extern<RT2>): R { (Extern<RT2>.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<RT2> { Extern<RT2>(v) }
}

type E = Extern<RT>

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func expectConverted(kinds: Array<String>, msg: String): Unit {
    let actual = RT.converted.toArray()
    check(actual == kinds, "${msg}: converted ${actual}, expected ${kinds}")
    RT.converted.clear()
}

func expectAccesses(kinds: Array<String>, msg: String): Unit {
    let actual = RT.accesses.toArray()
    check(actual == kinds, "${msg}: accesses ${actual}, expected ${kinds}")
    RT.accesses.clear()
}

func int(e: Extern<RT>): Int64 { RT.fromExtern<Int64>(e) }

let gNone: ?Extern<RT> = None
let gConv: Extern<RT> = gNone ?? 7

class C {
    var f: Extern<RT> = gNone ?? 6
}

struct S {
    let f: Extern<RT>
    init(o: ?Extern<RT>) {
        f = o ?? 9
    }
}

func takes(p: Extern<RT>): Extern<RT> { p }

func returns(o: ?Extern<RT>): Extern<RT> {
    return o ?? 1
}

func body(o: ?Extern<RT>): Extern<RT> {
    o ?? 2
}

func defaulted(p!: Extern<RT> = gNone ?? 3): Extern<RT> { p }

func generic<R>(o: ?Extern<R>, x: Int64): Extern<R> where R <: ForeignRuntime<R> {
    o ?? x
}

func genericOther<R, U>(o: ?Extern<R>, x: U): Extern<R> where R <: ForeignRuntime<R> {
    o ?? x
}

func inferred<R>(p: Extern<R>): Extern<R> where R <: ForeignRuntime<R> { p }

var evaluations = 0

func next(): ?Extern<RT> {
    evaluations++
    None
}

func sideEffect(): Int64 {
    evaluations++
    5
}

main() {
    expectConverted(["Int64"], "global initializer")
    let c = true
    let e = Extern<RT>(0)
    let e2 = Extern<RT2>(0)
    let none: ?Extern<RT> = None
    let some: ?Extern<RT> = Some(e)
    let intNone: ?Int64 = None

    // Contexts.
    let a: Extern<RT> = none ?? 8
    expectConverted(["Int64"], "initializer")
    check(int(a) == 8, "initializer value")

    let inferredTy = none ?? 8
    expectConverted(["Int64"], "initializer without type")
    check(int(inferredTy) == 8, "initializer without type value")

    var v: Extern<RT> = e
    v = none ?? "s"
    expectConverted(["String"], "assignment")

    takes(none ?? true)
    expectConverted(["Bool"], "argument")

    check(int(returns(none)) == 1, "return")
    expectConverted(["Int64"], "return")
    check(int(body(none)) == 2, "body")
    expectConverted(["Int64"], "body")
    check(int(defaulted()) == 3, "default value")
    expectConverted(["Int64"], "default value")
    check(int(gConv) == 7, "global")
    expectConverted([], "global already converted")
    check(int(C().f) == 6, "member initializer")
    expectConverted(["Int64"], "member initializer")
    check(int(S(None).f) == 9, "constructor assignment")
    expectConverted(["Int64"], "constructor assignment")

    let l: () -> Extern<RT> = { => none ?? 4 }
    check(int(l()) == 4, "lambda")
    expectConverted(["Int64"], "lambda")
    let lr: () -> Extern<RT> = { => return none ?? 4 }
    lr()
    expectConverted(["Int64"], "return in lambda")

    let arr: Array<Extern<RT>> = [none ?? 1, none ?? "a", e]
    expectConverted(["Int64", "String"], "array literal")
    let tpl: (Extern<RT>, Int64) = (none ?? 1, 2)
    expectConverted(["Int64"], "tuple literal")

    let list = ArrayList<Extern<RT>>()
    list.add(none ?? 1)
    list[0] = none ?? 2
    expectConverted(["Int64", "Int64"], "ArrayList")
    let map = HashMap<String, Extern<RT>>()
    map["k"] = none ?? 3
    expectConverted(["Int64"], "HashMap")

    let fut: Future<Extern<RT>> = spawn { none ?? 5 }
    check(int(fut.get()) == 5, "spawn")
    expectConverted(["Int64"], "spawn")

    none ?? 8
    expectConverted(["Int64"], "discarded value")

    match (none ?? 1) {
        case _ => ()
    }
    expectConverted(["Int64"], "selector")

    let aliasNone: ?E = None
    let ea: E = aliasNone ?? 4
    expectConverted(["Int64"], "type alias")

    // Short-circuit and single evaluation.
    let s1: Extern<RT> = some ?? sideEffect()
    expectConverted([], "Some is not converted")
    check(evaluations == 0, "right operand is not evaluated for Some")
    check(int(s1) == 0, "Some value")
    let s2: Extern<RT> = next() ?? sideEffect()
    expectConverted(["Int64"], "single evaluation")
    check(evaluations == 2, "left and right are evaluated once")

    // Shapes of the right operand.
    let chain: Extern<RT> = none ?? none ?? 8
    expectConverted(["Int64"], "chain")
    let chainSome: Extern<RT> = none ?? some ?? 8
    expectConverted([], "chain with Some")
    let innerInt: Extern<RT> = none ?? (intNone ?? 5)
    expectConverted(["Int64"], "inner coalescing of Int64")
    check(int(innerInt) == 5, "inner coalescing of Int64 value")
    let withIf: Extern<RT> = none ?? if (c) { 1 } else { 2 }
    expectConverted(["Int64"], "if")
    let withMatch: Extern<RT> = none ?? match (c) {
        case true => "a"
        case _ => "b"
    }
    expectConverted(["String"], "match")
    let withTry: Extern<RT> = none ?? try { 1 } catch (_: Exception) { 2 }
    expectConverted(["Int64"], "try")
    let withUnsafe: Extern<RT> = none ?? unsafe { 5 }
    expectConverted(["Int64"], "unsafe")
    let withLambda: Extern<RT> = none ?? { => 1 }
    expectConverted(["other"], "lambda operand")
    let withUnit: Extern<RT> = none ?? ()
    expectConverted(["Unit"], "unit")
    var y = 0
    let withAssign: Extern<RT> = none ?? (y = 1)
    expectConverted(["Unit"], "assignment operand")
    check(y == 1, "assignment operand evaluated")
    let withInterp: Extern<RT> = none ?? "${y}"
    expectConverted(["String"], "interpolation")
    let o2: ?Int64 = Some(4)
    let withOptChain: Extern<RT> = none ?? o2?.toString()
    expectConverted(["Option<String>"], "optional chain operand")
    let withOption: Extern<RT> = none ?? Some(1)
    expectConverted(["Option<Int64>"], "Option operand")
    let withExtern: Extern<RT> = none ?? e
    expectConverted([], "Extern operand")
    let withCross: Extern<RT> = none ?? e2
    expectConverted(["Extern<RT2>"], "Extern of another runtime")
    let withDynamic: Extern<RT> = none ?? e.f
    expectConverted([], "dynamic operand")
    expectAccesses(["f"], "dynamic operand")
    try {
        let withThrow: Extern<RT> = none ?? throw Exception("thrown")
    } catch (_: Exception) {}
    expectConverted([], "throw")

    // Coalescing in and around dynamic operations.
    let eo: ?Extern<RT> = Some(e)
    let optChainLeft: Extern<RT> = eo?.f ?? 8
    expectConverted([], "optional chain on Extern, Some")
    expectAccesses(["f"], "optional chain on Extern, Some")
    let receiver = (none ?? 10).f
    expectConverted(["Int64"], "receiver")
    expectAccesses(["f"], "receiver")
    e.f = none ?? 11
    expectConverted(["Int64"], "update value")
    expectAccesses(["f="], "update value")
    e(none ?? 1)
    expectConverted(["Int64"], "call argument")
    expectAccesses(["()"], "call argument")
    e[none ?? 0]
    expectConverted(["Int64"], "index")
    expectAccesses(["[]"], "index")
    e.f += none ?? 2
    expectConverted(["Int64"], "compound member update")
    expectAccesses(["f", "+", "()", "f="], "compound member update")
    e[none ?? 0] += none ?? 3
    expectConverted(["Int64", "Int64"], "compound index update")
    expectAccesses(["[]", "+", "()", "[]="], "compound index update")
    var ev: Extern<RT> = e
    ev += none ?? 4
    expectConverted(["Int64"], "compound Extern variable")

    // A match of type Extern containing a coalescing.
    let outer: Extern<RT> = match (c) {
        case true => none ?? 8
        case _ => e
    }
    expectConverted(["Int64"], "coalescing in a match case")
    let outerIf: Extern<RT> = if (c) { none ?? 8 } else { e }
    expectConverted(["Int64"], "coalescing in an if branch")

    // Generics.
    check(int(generic<RT>(None, 12)) == 12, "generic")
    expectConverted(["Int64"], "generic")
    check(int(generic<RT>(Some(e), 12)) == 0, "generic Some")
    expectConverted([], "generic Some")
    check(RT.fromExtern<String>(genericOther<RT, String>(None, "g")) == "g", "generic operand type")
    expectConverted(["String"], "generic operand type")
    inferred(none ?? 3)
    expectConverted(["Int64"], "inferred runtime")
    0
}
