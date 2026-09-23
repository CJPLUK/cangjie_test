// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.HashMap

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
            case "id" => e
            case "pi" => Extern<DummyRT>.ExternPayload(3.14)
            case "add"=> Extern<DummyRT>.ExternPayload((externPayload(e) as Int64).getOrThrow() + 1)
            case "sub"=> Extern<DummyRT>.ExternPayload((externPayload(e) as Int64).getOrThrow() - 1)
            case _ => throw ExternMemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexedAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>.ExternPayload((externPayload(e) as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
        } else if (index is String) {
            Extern<DummyRT>.ExternPayload((externPayload(e) as HashMap<String, Array<Int64>>).getOrThrow()[(index as String).getOrThrow()])
        } else if (index is Extern<DummyRT>) {
            (index as Extern<DummyRT>).getOrThrow()
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
            case _: Option<Float64> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<Rune> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<UInt32> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<Int32> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<HashMap<String, Array<Int64>>> => (externPayload(eval(h)) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let m = HashMap<String, Array<Int64>>()
    m["one"] = [1, 2, 3]
    m["two"] = [4, 5, 6]
    m["three"] = [7, 8, 9]
    let e = Extern<DummyRT>.ExternPayload(m)

    if (DummyRT.fromExtern<Int64>(e["one"][0]) != 1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e["one"][0].id) != 1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e["one"][0].id.sub) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.id["one"][0].id.sub) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(e.id["one"][0].id.sub.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<HashMap<String, Array<Int64>>>(e.id["one"][0].id.sub.pi[e])["one"][1] != 2) {
        throw Exception("Unexpected!")
    }

    try {
        DummyRT.fromExtern<HashMap<String, Array<String>>>(e.id["one"][0].id.sub.pi[e])["one"][1]
        throw Exception("Unexpected!")
    } catch (e: ExternConversionException) {
        // Expected
    }
    0
}