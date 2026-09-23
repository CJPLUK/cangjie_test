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
            case "length" =>
                let a = (externPayload(e) as Array<Int64>).getOrThrow()
                Extern<DummyRT>.ExternPayload(a.size)
            case _ => throw Exception("memberAccess not implemented")
        }
    }
    public static func indexedAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>.ExternPayload((externPayload(e) as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
        } else {
            throw Exception("indexedAccess not implemented")
        }
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexedUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => (externPayload(eval(h)) as R).getOrThrow()
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

func convertArrayToArrayList<T>(array: Extern<DummyRT>): ArrayList<T> {
    let arrayLength: Extern<DummyRT> = array.length
    let arrayLengthInt64: Int64 = DummyRT.fromExtern<Int64>(arrayLength)
    ArrayList<T>(arrayLengthInt64, { i: Int64 =>
        DummyRT.fromExtern<T>(array[i])
    })
}

main () {
    let a = [1, 2, 3]
    let e = Extern<DummyRT>.ExternPayload(a)
    let al = convertArrayToArrayList<Int64>(e)
    if (al.size != 3) {
        throw Exception("size is not 3")
    }
    if (al[0] != 1) {
        throw Exception("al[0] is not 1")
    }
    if (al[1] != 2) {
        throw Exception("al[1] is not 2")
    }
    if (al[2] != 3) {
        throw Exception("al[2] is not 3")
    }
    println("al=${al}")
    return 0
}