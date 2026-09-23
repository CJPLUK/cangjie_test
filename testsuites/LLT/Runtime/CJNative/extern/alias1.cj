// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.ArrayList

func externPayload<T>(e: Extern<T>): Any where T <: ForeignRuntime<T> {
    match (e) {
        case ExternPayload(value) => value
        case _ => throw Exception("expected ExternPayload")
    }
}

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        match (t) {
            case ExternPayload(_) => t
            case ExternMemberAccess(receiver, field) => memberAccess(eval(receiver), field)
            case ExternIndexedAccess(receiver, index) => indexedAccess(eval(receiver), evalOperand(index))
            case ExternMemberUpdate(receiver, field, value) => applyMemberUpdate(eval(receiver), field, evalOperand(value))
            case ExternIndexedUpdate(receiver, index, value) => applyIndexedUpdate(eval(receiver), evalOperand(index), evalOperand(value))
            case ExternFunctionCall(receiver, args) => functionCall(eval(receiver), evalArgs(args))
            case ExternCompoundAssignment(_, _, _) => throw ExternCompoundAssignmentException()
            case _ => Extern<DummyRT>.evalDerived(t)
        }
    }

    static func evalOperand(value: Any): Any {
        match (value) {
            case e: Extern<DummyRT> => eval(e)
            case _ => value
        }
    }

    static func evalArgs(args: Array<Any>): Array<Any> {
        Array<Any>(args.size, {i => evalOperand(args[i])})
    }

    static func applyMemberUpdate(receiver: Extern<DummyRT>, field: String, value: Any): Extern<DummyRT> {
        memberUpdate(receiver, field, value)
        receiver
    }

    static func applyIndexedUpdate(receiver: Extern<DummyRT>, index: Any, value: Any): Extern<DummyRT> {
        indexedUpdate(receiver, index, value)
        receiver
    }

    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "id" => Extern<DummyRT>.ExternPayload(42)
            case _ => throw Exception("not implemented")
        }
    }
    public static func indexedAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        throw Exception("not implemented")
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any) : Unit  {
        throw Exception("not implemented")
    }
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("not implemented")
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw Exception("not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => (externPayload(eval(h)) as R).getOrThrow()
            case _ => throw Exception("not implemented")
        }
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>.ExternPayload(v)
    }
}

type Z = Extern<DummyRT>
type Y = Z
type X = Y

func foo(x: X): Int64 {
    DummyRT.fromExtern<Int64>(x)
}

main () {
    let x: X = 42

    DummyRT.fromExtern<Int64>(x) - foo(x)
}
