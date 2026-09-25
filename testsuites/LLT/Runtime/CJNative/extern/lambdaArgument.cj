// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A lambda passed to a dynamic call is a leaf of the tree of the call, and the dynamic
// operations in its body are desugared on their own, when the lambda is called:
//   e1.f(e2, {e3: Extern<T> => e3.b.c}, e4)
// is desugared into
//   T.eval(ExternFunctionCall(ExternMemberAccess(e1, "f"),
//       [e2, {e3: Extern<T> => T.eval(ExternMemberAccess(ExternMemberAccess(e3, "b"), "c"))}, e4]))
// `eval` records the tree it receives, showing a lambda argument as `<lambda>`. Like a
// foreign function calling back into Cangjie, it then calls each lambda argument.

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
    match (t) {
        case ExternPayload(value) => anyToString(value)
        case ExternMemberAccess(receiver, field) => show(receiver) + "." + field
        case ExternFunctionCall(receiver, args) =>
            show(receiver) + "(" + String.join(Array<String>(args.size, {i => anyToString(args[i])}), delimiter: ", ") + ")"
        case _ => "?"
    }
}

class TraceRT <: ForeignRuntime<TraceRT> {
    public static func eval(t: Extern<TraceRT>): Extern<TraceRT> {
        println("eval")
        trace += show(t) + ";"
        match (t) {
            case ExternFunctionCall(_, args) => callBack(args)
            case _ => ()
        }
        t
    }

    private static func callBack(args: Array<Any>): Unit {
        for (arg in args) {
            match (arg) {
                case f: (Extern<TraceRT>) -> Extern<TraceRT> => f(Extern<TraceRT>.ExternPayload("e3"))
                case _ => ()
            }
        }
    }

    public static func fromExtern<R>(_: Extern<TraceRT>): R {
        throw Exception("fromExtern is not used")
    }

    public static func toExtern<R>(v: R): Extern<TraceRT> {
        Extern<TraceRT>.ExternPayload(v)
    }
}

main() {
    let e1 = Extern<TraceRT>.ExternPayload("e1")
    let e2 = Extern<TraceRT>.ExternPayload("e2")
    let e4 = Extern<TraceRT>.ExternPayload("e4")
    e1.f(e2, {e3: Extern<TraceRT> => e3.b.c}, e4)
    let expected = "e1.f(e2, <lambda>, e4);e3.b.c;"
    if (trace != expected) {
        throw Exception("expected '" + expected + "' but got '" + trace + "'")
    }
    0
}
