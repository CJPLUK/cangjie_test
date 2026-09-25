// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Multiple assignment `(x1, ..., xn) = (v1, ..., vn)` is desugared before `Extern`
// operations, so it keeps its usual meaning: the right-hand side is evaluated first, then
// each element is assigned in order. An element `e.f` or `e[i]` with `e: Extern<T>` is a
// dynamic update, and a dynamic value is evaluated with its own `T.eval`.
// `eval` records the tree it receives and returns it as a payload.

var trace: String = ""
var calls: Int64 = 0

func anyToString(v: Any): String {
    match (v) {
        case e: Extern<TraceRT> => show(e)
        case i: Int64 => i.toString()
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

func id(e: Extern<TraceRT>): Extern<TraceRT> {
    calls++
    e
}

func check(actual: String, expected: String, what: String): Unit {
    if (actual != expected) {
        throw Exception(what + ": expected '" + expected + "' but got '" + actual + "'")
    }
}

func reset(): Unit {
    trace = ""
    calls = 0
}

main() {
    let e = Extern<TraceRT>.ExternPayload("e")

    var b = 0
    reset()
    (e.x, b) = (1, 2)
    check(trace, "e.x = 1;", "(e.x, b) = (1, 2)")
    if (b != 2) {
        throw Exception("(e.x, b) = (1, 2): expected b to be 2 but got ${b}")
    }

    var v = Extern<TraceRT>.ExternPayload("v")
    reset()
    (e[0], v, e.y.z) = (e.w, e.u(1), 3)
    check(trace, "e.w;e.u(1);e[0] = e.w;e.y.z = 3;", "(e[0], v, e.y.z) = (e.w, e.u(1), 3)")
    check(TraceRT.fromExtern<String>(v), "e.u(1)", "value of v after (e[0], v, e.y.z) = (e.w, e.u(1), 3)")

    reset()
    (id(e).p, _) = (e.q, 1)
    check(trace, "e.q;e.p = e.q;", "(id(e).p, _) = (e.q, 1)")
    if (calls != 1) {
        throw Exception("(id(e).p, _) = (e.q, 1): expected 1 call but got ${calls}")
    }
    0
}
