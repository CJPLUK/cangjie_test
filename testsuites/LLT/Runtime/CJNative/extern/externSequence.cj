// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt --experimental --enable-extern-sequence %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// With `--enable-extern-sequence`, consecutive generated evaluations `T.eval(E1); T.eval(E2)`, whose first result is
// unused and with only side-effect free code in between, are merged into `T.eval(ExternSequence(E1, E2))`.
// `eval` records the trees it receives; for `ExternSequence` it records "seq" and falls back to `evalDerived`, which
// evaluates both operands in order.

var trace: String = ""
var counter: Int64 = 0

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
        case ExternMemberUpdate(receiver, field, value) => show(receiver) + "." + field + " = " + anyToString(value)
        case ExternFunctionCall(receiver, args) =>
            show(receiver) + "(" + String.join(Array<String>(args.size, {i => anyToString(args[i])}), delimiter: ", ") + ")"
        case _ => "?"
    }
}

class TraceRT <: ForeignRuntime<TraceRT> {
    public static func eval(t: Extern<TraceRT>): Extern<TraceRT> {
        match (t) {
            case ExternSequence(_, _) =>
                trace += "seq;"
                Extern<TraceRT>.evalDerived(t)
            case _ =>
                let tree = show(t)
                trace += tree + ";"
                counter++
                Extern<TraceRT>.ExternPayload(tree)
        }
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

class OtherRT <: ForeignRuntime<OtherRT> {
    public static func eval(t: Extern<OtherRT>): Extern<OtherRT> {
        trace += "other;"
        t
    }

    public static func fromExtern<R>(h: Extern<OtherRT>): R {
        throw Exception("unexpected fromExtern")
    }

    public static func toExtern<R>(v: R): Extern<OtherRT> {
        Extern<OtherRT>.ExternPayload(v)
    }
}

func check(expected: String, what: String): Unit {
    if (trace != expected) {
        throw Exception(what + ": expected '" + expected + "' but got '" + trace + "'")
    }
    trace = ""
}

func consecutive(e: Extern<TraceRT>): Unit {
    e.a = 1
    e.b = 2
    e.c = 3
}

func pureInBetween(e: Extern<TraceRT>, v: Int64): Unit {
    e.a = v
    let p = (v, 6)
    e.b = p[1]
}

// `v * 2` throws on overflow.
func mayThrowInBetween(e: Extern<TraceRT>, v: Int64): Unit {
    e.a = v
    let w = v * 2
    e.b = w
}

func impureInBetween(e: Extern<TraceRT>): Unit {
    e.a = 1
    trace += "between;"
    e.b = 2
}

// The second tree reads `counter` after the first evaluation, which may change it.
func loadInBetween(e: Extern<TraceRT>): Unit {
    e.a = 1
    e.b = counter
}

func resultUsed(e: Extern<TraceRT>): String {
    let r = e.f(1)
    e.b = 2
    TraceRT.fromExtern<String>(r)
}

func differentRuntimes(e: Extern<TraceRT>, o: Extern<OtherRT>): Unit {
    e.a = 1
    o.b = 2
    e.c = 3
}

func inTry(e: Extern<TraceRT>): Unit {
    try {
        e.a = 1
        e.b = 2
    } catch (ex: Exception) {
        trace += "caught;"
    }
}

main() {
    let e = Extern<TraceRT>.ExternPayload("e")

    consecutive(e)
    check("seq;seq;e.a = 1;e.b = 2;e.c = 3;", "consecutive")

    pureInBetween(e, 3)
    check("seq;e.a = 3;e.b = 6;", "pure code in between")

    mayThrowInBetween(e, 3)
    check("e.a = 3;e.b = 6;", "code that may throw in between")

    impureInBetween(e)
    check("e.a = 1;between;e.b = 2;", "impure code in between")

    counter = 0
    loadInBetween(e)
    check("e.a = 1;e.b = 1;", "load in between")

    check("", "reset")
    let r = resultUsed(e)
    check("e.f(1);e.b = 2;", "result used")
    if (r != "e.f(1)") {
        throw Exception("result used: expected 'e.f(1)' but got '" + r + "'")
    }

    differentRuntimes(e, Extern<OtherRT>.ExternPayload("o"))
    check("e.a = 1;other;e.c = 3;", "different runtimes")

    inTry(e)
    check("seq;e.a = 1;e.b = 2;", "in try")
    0
}
