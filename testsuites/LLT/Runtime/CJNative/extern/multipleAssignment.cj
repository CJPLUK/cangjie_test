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
// dynamic update, desugared into `T.memberUpdate` or `T.indexedUpdate`, and a dynamic value
// is evaluated on its own. The runtime records each operation and returns its description
// as a payload.

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
    anyToString(Extern.getPayload(t))
}

func record(name: String): Extern<TraceRT> {
    trace += name + ";"
    Extern<TraceRT>(name)
}

class TraceRT <: ForeignRuntime<TraceRT> {
    public static func memberAccess(e: Extern<TraceRT>, field: String): Extern<TraceRT> {
        record(show(e) + "." + field)
    }

    public static func indexedAccess(e: Extern<TraceRT>, arg: Any): Extern<TraceRT> {
        record(show(e) + "[" + anyToString(arg) + "]")
    }

    public static func memberUpdate(e: Extern<TraceRT>, field: String, value: Any): Unit {
        record(show(e) + "." + field + " = " + anyToString(value))
    }

    public static func indexedUpdate(e: Extern<TraceRT>, field: Any, value: Any): Unit {
        record(show(e) + "[" + anyToString(field) + "] = " + anyToString(value))
    }

    public static func functionCall(e: Extern<TraceRT>, args: Array<Any>): Extern<TraceRT> {
        record(show(e) + "(" + String.join(Array<String>(args.size, {i => anyToString(args[i])}), delimiter: ", ") + ")")
    }

    public static func fromExtern<R>(h: Extern<TraceRT>): R {
        (Extern.getPayload(h) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<TraceRT> {
        Extern<TraceRT>(v)
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
    let e = Extern<TraceRT>("e")

    var b = 0
    reset()
    (e.x, b) = (1, 2)
    check(trace, "e.x = 1;", "(e.x, b) = (1, 2)")
    if (b != 2) {
        throw Exception("(e.x, b) = (1, 2): expected b to be 2 but got ${b}")
    }

    var v = Extern<TraceRT>("v")
    reset()
    (e[0], v, e.y.z) = (e.w, e.u(1), 3)
    check(trace, "e.w;e.u;e.u(1);e[0] = e.w;e.y;e.y.z = 3;", "(e[0], v, e.y.z) = (e.w, e.u(1), 3)")
    check(TraceRT.fromExtern<String>(v), "e.u(1)", "value of v after (e[0], v, e.y.z) = (e.w, e.u(1), 3)")

    reset()
    (id(e).p, _) = (e.q, 1)
    check(trace, "e.q;e.p = e.q;", "(id(e).p, _) = (e.q, 1)")
    if (calls != 1) {
        throw Exception("(id(e).p, _) = (e.q, 1): expected 1 call but got ${calls}")
    }
    0
}
