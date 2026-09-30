// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.*

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static var converted: ArrayList<String> = ArrayList<String>()

    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (e) {
            case ExternPayload(value) => (value as R).getOrThrow()
            case _ => throw ExternConversionException("not a payload")
        }
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        let kind = match (v) {
            case _: Int64 => "Int64"
            case _: String => "String"
            case _: Bool => "Bool"
            case _: Unit => "Unit"
            case _ => "other"
        }
        converted.add(kind)
        Extern<DummyRT>.ExternPayload(v)
    }
}

open class Base {}

class A <: Base {}

class B <: Base {}

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func expectConverted(kinds: Array<String>, msg: String): Unit {
    let actual = DummyRT.converted.toArray()
    check(actual == kinds, "${msg}: converted ${actual}, expected ${kinds}")
    DummyRT.converted.clear()
}

func pick(c: Bool): Extern<DummyRT> {
    if (c) {
        1
    } else {
        "one"
    }
}

func id(x: Extern<DummyRT>): Extern<DummyRT> {
    x
}

main() {
    var c = true

    // Each branch is converted, so only the branch that runs converts its value.
    let same: Extern<DummyRT> = if (c) { 1 } else { 2 }
    expectConverted(["Int64"], "if with branches of the same type")

    let ifInt: Extern<DummyRT> = if (c) { 1 } else { "a" }
    expectConverted(["Int64"], "then branch")
    check(DummyRT.fromExtern<Int64>(ifInt) == 1, "then branch")
    c = false
    let ifStr: Extern<DummyRT> = if (c) { 1 } else { "a" }
    expectConverted(["String"], "else branch")
    check(DummyRT.fromExtern<String>(ifStr) == "a", "else branch")

    let elseIf: Extern<DummyRT> = if (c) { 1 } else if (!c) { "b" } else { true }
    expectConverted(["String"], "else if")

    // Branches with a common supertype are converted with their own types.
    let classes: Extern<DummyRT> = if (c) { A() } else { B() }
    expectConverted(["other"], "branches with a common supertype")
    check(DummyRT.fromExtern<B>(classes) is B, "branches with a common supertype")

    let e: Extern<DummyRT> = ifInt
    let withExtern: Extern<DummyRT> = if (c) { e } else { "x" }
    expectConverted(["String"], "Extern branch")
    c = true
    let externBranch: Extern<DummyRT> = if (c) { e } else { "x" }
    expectConverted([], "Extern branch was wrapped again")
    check(DummyRT.fromExtern<Int64>(externBranch) == 1, "Extern branch")

    let unitBranch: Extern<DummyRT> = if (!c) { 1 } else { let _ = 1 }
    expectConverted(["Unit"], "branch ending with a declaration")

    let noElse: Extern<DummyRT> = if (c) { () }
    expectConverted(["Unit"], "if without else")

    let m: Extern<DummyRT> = match (c) {
        case true => "yes"
        case false => 0
    }
    expectConverted(["String"], "match")
    check(DummyRT.fromExtern<String>(m) == "yes", "match")

    let externCase: Extern<DummyRT> = match (c) {
        case true => e
        case false => A()
    }
    expectConverted([], "Extern case was wrapped again")
    check(DummyRT.fromExtern<Int64>(externCase) == 1, "Extern case")

    let caught: Extern<DummyRT> = try {
        throw Exception()
    } catch (_: Exception) {
        "caught"
    }
    expectConverted(["String"], "catch block")
    let notCaught: Extern<DummyRT> = try {
        5
    } catch (_: Exception) {
        "caught"
    } finally {
        ()
    }
    expectConverted(["Int64"], "try block")
    check(DummyRT.fromExtern<Int64>(notCaught) == 5, "try block")

    let paren: Extern<DummyRT> = (if (c) { 1 } else { "p" })
    expectConverted(["Int64"], "branch in parentheses")

    let inArray: Array<Extern<DummyRT>> = [if (c) { 1 } else { "z" }, 7]
    expectConverted(["Int64", "Int64"], "branch in an array")

    check(DummyRT.fromExtern<Int64>(pick(true)) == 1, "returned branch")
    expectConverted(["Int64"], "returned branch")

    let lambda: (Bool) -> Extern<DummyRT> = { b => if (b) { 1 } else { "lambda" } }
    lambda(false)
    expectConverted(["String"], "lambda body")

    id(if (c) { true } else { 0 })
    expectConverted(["Bool"], "argument branch")

    var v: Extern<DummyRT> = e
    v = if (c) { "v" } else { 1 }
    expectConverted(["String"], "assigned branch")
    check(DummyRT.fromExtern<String>(v) == "v", "assigned branch")
    0
}
