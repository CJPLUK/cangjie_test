// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Values converted to Extern<T> in contexts that reach the conversion through other language features: generics,
// constructors, operator overloads, patterns, named, default and variadic arguments, collections, nested literals and
// control flow. Each check compares the number of calls to toExtern and the converted values.

import std.collection.*
import std.sync.*

var conversions: Int64 = 0

public class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<RT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<RT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<RT> {
        conversions++
        Extern<RT>(v)
    }
}

func expect(n: Int64, what: String): Unit {
    if (conversions != n) {
        throw Exception(what + ": expected ${n} conversions but got ${conversions}")
    }
    conversions = 0
}

func int(e: Extern<RT>): Int64 {
    RT.fromExtern<Int64>(e)
}

func str(e: Extern<RT>): String {
    RT.fromExtern<String>(e)
}

func checkInt(e: Extern<RT>, expected: Int64, what: String): Unit {
    if (int(e) != expected) {
        throw Exception(what + ": expected ${expected} but got ${int(e)}")
    }
}

// Generics.
class Cell<X> {
    var value: X
    init(value: X) {
        this.value = value
    }
    func set(v: X): Unit {
        value = v
    }
}

func identity<X>(x: X): X {
    x
}

func pair<X, Y>(x: X, y: Y): (X, Y) {
    (x, y)
}

// Constructors.
class Primary {
    Primary(let first: Extern<RT>, var second!: Extern<RT> = "default") {}
}

open class Base {
    let fromSuper: Extern<RT>
    init(x: Extern<RT>) {
        fromSuper = x
    }
}

class Derived <: Base {
    init() {
        super(1)
    }
    init(n: Int64) {
        this()
    }
}

struct Point {
    let x: Extern<RT>
    let y: Extern<RT>
    init(x: Extern<RT>, y: Extern<RT>) {
        this.x = x
        this.y = y
    }
    init(v: Int64) {
        this(v, v * 10)
    }
}

enum Shape {
    | Circle(Extern<RT>)
    | Rect(Int64, Extern<RT>)
}

// Operator overloads.
class Acc {
    var total: Int64 = 0
    var last: Extern<RT> = Extern<RT>(0)
    operator func +(x: Extern<RT>): Acc {
        total += int(x)
        this
    }
    operator func [](i: Extern<RT>): Int64 {
        int(i) * 2
    }
    operator func [](i: Int64, value!: Extern<RT>): Unit {
        last = value
    }
    operator func ()(x: Extern<RT>, y: Extern<RT>): Int64 {
        int(x) + int(y)
    }
}

class Holder {
    var acc = Acc()
    static let fromStatic: Extern<RT>
    static init() {
        fromStatic = 7
    }
    var backing: Extern<RT> = Extern<RT>(0)
    mut prop p: Extern<RT> {
        get() {
            unsafe { 11 }
        }
        set(v) {
            backing = v
        }
    }
}

// Arguments.
func named(a!: Int64 = 0, b!: Extern<RT> = 5, c!: Extern<RT> = "c"): Int64 {
    a + int(b)
}

func variadic(n: Int64, xs: Array<Extern<RT>>): Int64 {
    var sum = n
    for (x in xs) {
        sum += int(x)
    }
    sum
}

func consume(x: Extern<RT>): Extern<RT> {
    x
}

// Control flow giving the value.
func classify(n: Int64): Extern<RT> {
    if (n < 0) {
        return "negative"
    } else if (n == 0) {
        "zero"
    } else if (n < 10) {
        match (n % 2) {
            case 0 => n
            case _ => unsafe { -n }
        }
    } else {
        let big = n * 2
        try {
            if (big > 100) {
                throw Exception()
            }
            big
        } catch (_: Exception) {
            (big, 1)[0]
        }
    }
}

main() {
    // Static initializers run with the initialization of the package.
    expect(1, "static init")

    // Generics.
    let cell = Cell<Extern<RT>>(1)
    expect(1, "generic constructor")
    cell.set(2)
    expect(1, "generic method")
    cell.value = 3
    expect(1, "generic field")
    checkInt(cell.value, 3, "generic field value")
    let id: Extern<RT> = identity<Extern<RT>>(4)
    expect(1, "explicit generic call")
    checkInt(id, 4, "explicit generic call value")
    let p = pair<Extern<RT>, Int64>(5, 6)
    expect(1, "generic pair")
    checkInt(p[0], 5, "generic pair value")

    // Constructors.
    let primary = Primary(1)
    expect(2, "primary constructor with default")
    if (str(primary.second) != "default") {
        throw Exception("primary constructor default value")
    }
    primary.second = 2
    expect(1, "primary constructor var field")
    let derived = Derived(0)
    expect(1, "super and this calls")
    checkInt(derived.fromSuper, 1, "super call value")
    let pt = Point(3)
    expect(2, "struct this call")
    checkInt(pt.y, 30, "struct this call value")
    let shapes = [Circle(1), Shape.Rect(2, "w")]
    expect(2, "enum constructors")
    match (shapes[1]) {
        case Rect(_, w) => if (str(w) != "w") { throw Exception("enum constructor value") }
        case _ => throw Exception("enum constructor")
    }

    // Operator overloads.
    var acc = Acc()
    let _ = acc + 1
    expect(1, "binary operator")
    acc += 2
    expect(1, "compound assignment with operator")
    let holder = Holder()
    holder.acc += 3
    expect(1, "compound assignment on field with operator")
    if (acc.total != 3 || holder.acc.total != 3) {
        throw Exception("operator totals")
    }
    if (acc[4] != 8) {
        throw Exception("subscript getter value")
    }
    expect(1, "subscript getter index")
    acc[0] = 5
    expect(1, "subscript setter value")
    checkInt(acc.last, 5, "subscript setter value")
    if (acc(1, "a".size) != 2) {
        throw Exception("call operator value")
    }
    expect(2, "call operator")

    // Statics and properties.
    checkInt(Holder.fromStatic, 7, "static init")
    checkInt(holder.p, 11, "property getter")
    expect(1, "property getter")
    holder.p = 12
    expect(1, "property setter")

    // Patterns.
    let _ : Extern<RT> = 1
    expect(1, "wildcard pattern")
    let (a, (b, _)): (Extern<RT>, (Extern<RT>, Int64)) = (1, ("b", 2))
    expect(2, "nested tuple pattern")
    checkInt(a, 1, "nested tuple pattern value")
    var x: Extern<RT> = a
    var n = 0
    (x, n) = (3, 4)
    expect(1, "tuple assignment")
    checkInt(x, 3, "tuple assignment value")

    // Arguments.
    if (named(b: 1, a: 2) != 3) {
        throw Exception("named arguments value")
    }
    expect(2, "named arguments with default")
    if (named() != 5) {
        throw Exception("default arguments value")
    }
    expect(2, "default arguments")
    if (variadic(1, 2, 3, 4) != 10) {
        throw Exception("variadic value")
    }
    expect(3, "variadic arguments")
    let piped = 9 |> consume
    expect(1, "pipeline")
    checkInt(piped, 9, "pipeline value")
    let none: ?Extern<RT> = None
    let coalesced: Extern<RT> = none ?? 8
    expect(1, "coalescing")
    checkInt(coalesced, 8, "coalescing value")
    let some: ?Extern<RT> = Some<Extern<RT>>(7)
    expect(1, "explicit Some")

    // Collections and nested literals.
    let list = ArrayList<Extern<RT>>()
    list.add(1)
    list.add(all: [2, "three"])
    list[0] = 0
    expect(4, "ArrayList")
    let map = HashMap<String, Extern<RT>>()
    map["k"] = 1
    expect(1, "HashMap")
    let nested: (Extern<RT>, Array<(Int64, Extern<RT>)>) = (1, [(2, 3), (4, "five")])
    expect(3, "nested literals")
    if (str(nested[1][1][1]) != "five") {
        throw Exception("nested literals value")
    }
    let repeated = Array<Extern<RT>>(3, repeat: 1)
    let generated = Array<Extern<RT>>(3, {i => i * i})
    expect(4, "Array constructors")
    checkInt(generated[2], 4, "Array constructor value")
    let col: Collection<Extern<RT>> = [1, 2]
    expect(2, "array literal as Collection")

    // Control flow giving the value.
    if (str(classify(-1)) != "negative" || str(classify(0)) != "zero") {
        throw Exception("return and else-if values")
    }
    checkInt(classify(4), 4, "match value")
    checkInt(classify(3), -3, "unsafe block value")
    checkInt(classify(20), 40, "try value")
    checkInt(classify(60), 120, "catch value")
    expect(6, "control flow")

    // Lambdas, spawn and synchronized.
    let lambdas: Array<(Int64) -> Extern<RT>> = [{ v => v }, { v => if (v > 0) { return "pos" }; v }]
    checkInt(lambdas[0](1), 1, "lambda body")
    if (str(lambdas[1](1)) != "pos") {
        throw Exception("lambda return")
    }
    expect(2, "lambdas")
    let future: Future<Extern<RT>> = spawn { 1 + 1 }
    checkInt(future.get(), 2, "spawn value")
    expect(1, "spawn")
    let m = Mutex()
    let s: (Extern<RT>, Int64) = (synchronized (m) { 3 }, 4)
    expect(1, "synchronized in tuple")
    checkInt(s[0], 3, "synchronized value")
    0
}
