// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.*

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

    public static var converted: ArrayList<String> = ArrayList<String>()

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
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
        Extern<DummyRT>(v)
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
        2
    }
}

func id(x: Extern<DummyRT>): Extern<DummyRT> {
    x
}

main() {
    var c = true

    // An if, a match or a try is converted as a whole, with the common type of its branches, once it is evaluated.
    let same: Extern<DummyRT> = if (c) { 1 } else { 2 }
    expectConverted(["Int64"], "if")
    check(DummyRT.fromExtern<Int64>(same) == 1, "if")

    c = false
    let elseIf: Extern<DummyRT> = if (c) { "a" } else if (!c) { "b" } else { "c" }
    expectConverted(["String"], "else if")
    check(DummyRT.fromExtern<String>(elseIf) == "b", "else if")

    let classes: Extern<DummyRT> = if (c) { A() } else { B() }
    expectConverted(["other"], "branches with a common supertype")
    check(DummyRT.fromExtern<Base>(classes) is B, "branches with a common supertype")

    // Branches of type Extern<T> need no conversion.
    let e: Extern<DummyRT> = same
    let e2 = Extern<DummyRT>(2)
    let externs: Extern<DummyRT> = if (c) { e } else { e2 }
    expectConverted([], "Extern branches")
    check(DummyRT.fromExtern<Int64>(externs) == 2, "Extern branches")

    // A branch of type Extern<T> and a branch of another type have the common type Any.
    c = true
    let withExtern: Extern<DummyRT> = if (c) { e } else { B() }
    expectConverted(["other"], "Extern and non-Extern branches")
    check(Extern<DummyRT>.getPayload(withExtern) is Extern<DummyRT>, "Extern and non-Extern branches")

    let m: Extern<DummyRT> = match (c) {
        case true => "yes"
        case false => "no"
    }
    expectConverted(["String"], "match")
    check(DummyRT.fromExtern<String>(m) == "yes", "match")

    let caught: Extern<DummyRT> = try {
        throw Exception()
    } catch (_: Exception) {
        "caught"
    }
    expectConverted(["String"], "catch block")
    check(DummyRT.fromExtern<String>(caught) == "caught", "catch block")
    let notCaught: Extern<DummyRT> = try {
        5
    } catch (_: Exception) {
        6
    } finally {
        ()
    }
    expectConverted(["Int64"], "try block")
    check(DummyRT.fromExtern<Int64>(notCaught) == 5, "try block")

    let paren: Extern<DummyRT> = (if (c) { 1 } else { 2 })
    expectConverted(["Int64"], "if in parentheses")

    let inArray: Array<Extern<DummyRT>> = [if (c) { 1 } else { 2 }, 7]
    expectConverted(["Int64", "Int64"], "if in an array")

    check(DummyRT.fromExtern<Int64>(pick(true)) == 1, "returned if")
    expectConverted(["Int64"], "returned if")

    let lambda: (Bool) -> Extern<DummyRT> = { b => if (b) { "yes" } else { "lambda" } }
    lambda(false)
    expectConverted(["String"], "lambda body")

    id(if (c) { true } else { false })
    expectConverted(["Bool"], "argument")

    var v: Extern<DummyRT> = e
    v = if (c) { "v" } else { "w" }
    expectConverted(["String"], "assigned if")
    check(DummyRT.fromExtern<String>(v) == "v", "assigned if")
    0
}
