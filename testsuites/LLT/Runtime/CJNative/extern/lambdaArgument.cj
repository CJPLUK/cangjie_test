// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A lambda passed to a dynamic call is an argument of the call, and the dynamic
// operations in its body are desugared on their own, when the lambda is called:
//   e1.f(e2, {e3: Extern<T> => e3.b.c}, e4)
// is desugared into
//   T.functionCall(T.memberAccess(e1, "f"),
//       [e2, {e3: Extern<T> => T.memberAccess(T.memberAccess(e3, "b"), "c")}, e4])
// The runtime records each operation it performs, showing a lambda argument as `<lambda>`.
// Like a foreign function calling back into Cangjie, `functionCall` then calls each lambda argument.

var trace: String = ""

func anyToString(v: Any): String {
    match (v) {
        case e: Extern<TraceRT> => show(e)
        case _: (Extern<TraceRT>) -> Extern<TraceRT> => "<lambda>"
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
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<TraceRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<TraceRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<TraceRT>, args: Array<Any>): Extern<TraceRT> {
        let result = record(
            show(e) + "(" + String.join(Array<String>(args.size, {i => anyToString(args[i])}), delimiter: ", ") + ")")
        callBack(args)
        result
    }

    private static func callBack(args: Array<Any>): Unit {
        for (arg in args) {
            match (arg) {
                case f: (Extern<TraceRT>) -> Extern<TraceRT> => f(Extern<TraceRT>("e3"))
                case _ => ()
            }
        }
    }

    public static func fromExtern<R>(_: Extern<TraceRT>): R {
        throw Exception("fromExtern is not used")
    }

    public static func toExtern<R>(v: R): Extern<TraceRT> {
        Extern<TraceRT>(v)
    }
}

main() {
    let e1 = Extern<TraceRT>("e1")
    let e2 = Extern<TraceRT>("e2")
    let e4 = Extern<TraceRT>("e4")
    e1.f(e2, {e3: Extern<TraceRT> => e3.b.c}, e4)
    let expected = "e1.f;e1.f(e2, <lambda>, e4);e3.b;e3.b.c;"
    if (trace != expected) {
        throw Exception("expected '" + expected + "' but got '" + trace + "'")
    }
    0
}
