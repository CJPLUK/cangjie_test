// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Compound assignment `lhs op= v` with a left-hand side of type `Extern<T>` is decided by
// the last access of `lhs`:
// - a statically resolved left value (a variable, a field or property of a Cangjie object,
//   an element of a Cangjie array) is a normal compound assignment of type `Unit`, whose
//   operator is a dynamic call: `lhs = T.eval(ExternFunctionCall(ExternMemberAccess(lhs, "op"), [v]))`.
//   The receiver of `lhs` is evaluated once;
// - a dynamic access `e.f` or `e[i]` desugars to
//   `T.eval(ExternCompoundAssignment(<tree of e.f>, "op", v))`, of type `Extern<T>`.
// `eval` records the tree it receives and returns it as a payload.

var trace: String = ""
var calls: Int64 = 0

func anyToString(v: Any): String {
    match (v) {
        case e: Extern<TraceRT> => show(e)
        case i: Int64 => i.toString()
        case b: Bool => b.toString()
        case s: String => s
        case _ => "?"
    }
}

func show(t: Extern<TraceRT>): String {
    match (t) {
        case ExternPayload(value) => anyToString(value)
        case ExternMemberAccess(receiver, field) => show(receiver) + "." + field
        case ExternIndexedAccess(receiver, index) => show(receiver) + "[" + anyToString(index) + "]"
        case ExternMemberUpdate(receiver, field, value) => show(receiver) + "." + field + " = " + anyToString(value)
        case ExternIndexedUpdate(receiver, index, value) =>
            show(receiver) + "[" + anyToString(index) + "] = " + anyToString(value)
        case ExternFunctionCall(receiver, args) =>
            show(receiver) + "(" + String.join(Array<String>(args.size, {i => anyToString(args[i])}), delimiter: ", ") + ")"
        case ExternCompoundAssignment(target, op, value) => show(target) + " " + op + "= " + anyToString(value)
        case _ => "?"
    }
}

class TraceRT <: ForeignRuntime<TraceRT> {
    public static func eval(t: Extern<TraceRT>): Extern<TraceRT> {
        let tree = show(t)
        trace += tree + ";"
        Extern<TraceRT>.ExternPayload(tree)
    }

    public static func fromExtern<R>(h: Extern<TraceRT>): R {
        match (h) {
            case ExternPayload(value) => (value as R).getOrThrow()
            case _ => throw Exception("expected ExternPayload")
        }
    }

    public static func toExtern<R>(v: R): Extern<TraceRT> {
        Extern<TraceRT>.ExternPayload(v)
    }
}

class Holder {
    var x: Extern<TraceRT> = Extern<TraceRT>.ExternPayload("x")
    static var sx: Extern<TraceRT> = Extern<TraceRT>.ExternPayload("sx")
    var px: Extern<TraceRT> = Extern<TraceRT>.ExternPayload("px")

    mut prop p: Extern<TraceRT> {
        get() {
            calls++
            px
        }
        set(v) {
            px = v
        }
    }

    func addToX(): Unit {
        x += 1
    }
}

struct Pair {
    var x: Extern<TraceRT> = Extern<TraceRT>.ExternPayload("px")
}

let holder = Holder()

func getHolder(): Holder {
    calls++
    holder
}

func next(): Int64 {
    calls++
    0
}

func id(e: Extern<TraceRT>): Extern<TraceRT> {
    calls++
    e
}

func check(actual: String, expected: String, what: String): Unit {
    if (actual != expected) {
        throw Exception(what + ": expected '" + expected + "' but got '" + actual + "'")
    }
}

func checkCalls(expected: Int64, what: String): Unit {
    if (calls != expected) {
        throw Exception(what + ": expected ${expected} calls but got ${calls}")
    }
}

func reset(): Unit {
    trace = ""
    calls = 0
}

main() {
    let e = Extern<TraceRT>.ExternPayload("e")

    // Statically resolved left values.
    var v = Extern<TraceRT>.ExternPayload("v")
    reset()
    let u: Unit = (v += 1)
    check(trace, "v.+(1);", "v += 1")
    check(TraceRT.fromExtern<String>(v), "v.+(1)", "value of v after v += 1")

    v = Extern<TraceRT>.ExternPayload("v")
    reset()
    v -= e.z
    check(trace, "v.-(e.z);", "v -= e.z")

    v = Extern<TraceRT>.ExternPayload("v")
    reset()
    v &&= true
    check(trace, "v.&&(true);", "v &&= true")

    reset()
    getHolder().x *= 2
    check(trace, "x.*(2);", "getHolder().x *= 2")
    checkCalls(1, "getHolder().x *= 2")
    check(TraceRT.fromExtern<String>(holder.x), "x.*(2)", "value of holder.x after getHolder().x *= 2")

    reset()
    holder.addToX()
    check(trace, "x.*(2).+(1);", "x += 1 in a method")
    check(TraceRT.fromExtern<String>(holder.x), "x.*(2).+(1)", "value of holder.x after x += 1 in a method")

    reset()
    Holder.sx -= 1
    check(trace, "sx.-(1);", "Holder.sx -= 1")
    check(TraceRT.fromExtern<String>(Holder.sx), "sx.-(1)", "value of Holder.sx after Holder.sx -= 1")

    reset()
    holder.p /= 3
    check(trace, "px./(3);", "holder.p /= 3")
    checkCalls(1, "holder.p /= 3")
    check(TraceRT.fromExtern<String>(holder.px), "px./(3)", "value of holder.px after holder.p /= 3")

    var pair = Pair()
    reset()
    pair.x %= 4
    check(trace, "px.%(4);", "pair.x %= 4")
    check(TraceRT.fromExtern<String>(pair.x), "px.%(4)", "value of pair.x after pair.x %= 4")

    let arr: Array<Extern<TraceRT>> = [Extern<TraceRT>.ExternPayload("a")]
    reset()
    arr[next()] **= 2
    check(trace, "a.**(2);", "arr[next()] **= 2")
    checkCalls(1, "arr[next()] **= 2")
    check(TraceRT.fromExtern<String>(arr[0]), "a.**(2)", "value of arr[0] after arr[next()] **= 2")

    // Dynamic last access.
    reset()
    let r: Extern<TraceRT> = (e.x += 1)
    check(trace, "e.x += 1;", "e.x += 1")
    check(TraceRT.fromExtern<String>(r), "e.x += 1", "value of e.x += 1")

    reset()
    id(e).x.y -= e.z
    check(trace, "e.x.y -= e.z;", "id(e).x.y -= e.z")
    checkCalls(1, "id(e).x.y -= e.z")

    reset()
    e[0] *= 2
    check(trace, "e[0] *= 2;", "e[0] *= 2")

    reset()
    e[0, 1] /= e.w
    check(trace, "e[0][1] /= e.w;", "e[0, 1] /= e.w")

    reset()
    e.g(1).h %= 2
    check(trace, "e.g(1).h %= 2;", "e.g(1).h %= 2")

    reset()
    e.q <<= 2
    check(trace, "e.q <<= 2;", "e.q <<= 2")

    reset()
    e.b ||= false
    check(trace, "e.b ||= false;", "e.b ||= false")
    0
}
