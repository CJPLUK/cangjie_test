// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.*
import std.sync.*

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
            case _: Unit => "Unit"
            case _: Range<Int64> => "Range<Int64>"
            case _: Future<Int64> => "Future<Int64>"
            case _: Option<String> => "Option<String>"
            case _ => "other"
        }
        converted.add(kind)
        Extern<DummyRT>.ExternPayload(v)
    }
}

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

func thrower(): Extern<DummyRT> {
    throw Exception("thrown")
}

main() {
    let c = false

    // Expressions of type Unit that are not made of blocks of code are converted as a whole.
    var y = 0
    let assign: Extern<DummyRT> = (y = 1)
    expectConverted(["Unit"], "assignment")
    check(y == 1, "assignment was evaluated")
    DummyRT.fromExtern<Unit>(assign)

    let inc: Extern<DummyRT> = y++
    expectConverted(["Unit"], "increment")
    check(y == 2, "increment was evaluated")

    let dec: Extern<DummyRT> = y--
    expectConverted(["Unit"], "decrement")
    check(y == 1, "decrement was evaluated")

    let unit: Extern<DummyRT> = ()
    expectConverted(["Unit"], "unit literal")
    DummyRT.fromExtern<Unit>(unit)

    // Other expressions are converted as a whole too, with their own type.
    let lambda: Extern<DummyRT> = { => 1 }
    expectConverted(["other"], "lambda")
    check(DummyRT.fromExtern<() -> Int64>(lambda)() == 1, "lambda")

    let future: Extern<DummyRT> = spawn { 2 }
    expectConverted(["Future<Int64>"], "spawn")
    check(DummyRT.fromExtern<Future<Int64>>(future).get() == 2, "spawn")

    let range: Extern<DummyRT> = 1..3
    expectConverted(["Range<Int64>"], "range")
    check(DummyRT.fromExtern<Range<Int64>>(range).end == 3, "range")

    let o = Some(4)
    let optChain: Extern<DummyRT> = o?.toString()
    expectConverted(["Option<String>"], "optional chain")
    check(DummyRT.fromExtern<Option<String>>(optChain) == Some("4"), "optional chain")

    let interp: Extern<DummyRT> = "${y}"
    expectConverted(["String"], "string interpolation")
    check(DummyRT.fromExtern<String>(interp) == "1", "string interpolation")

    // synchronized is converted as a whole, after the lock is released.
    let m = Mutex()
    let sync: Extern<DummyRT> = synchronized (m) { 5 }
    expectConverted(["Int64"], "synchronized")
    check(DummyRT.fromExtern<Int64>(sync) == 5, "synchronized")

    // unsafe blocks and if-let are a block and an if: their values are converted, not the whole expression.
    let u: Extern<DummyRT> = unsafe { 6 }
    expectConverted(["Int64"], "unsafe block")
    check(DummyRT.fromExtern<Int64>(u) == 6, "unsafe block")

    let ifLet: Extern<DummyRT> = if (let Some(v) <- o) { v } else { "none" }
    expectConverted(["Int64"], "if-let")
    check(DummyRT.fromExtern<Int64>(ifLet) == 4, "if-let")

    // Nothing is a subtype of Extern<T>: no conversion.
    try {
        thrower()
    } catch (_: Exception) {}
    expectConverted([], "throw")
    0
}
