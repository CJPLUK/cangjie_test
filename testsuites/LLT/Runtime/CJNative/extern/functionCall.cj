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
            case "foo" => Extern<DummyRT>.ExternPayload({input: Array<Any> =>
                Extern<DummyRT>.ExternPayload("function call with input size ${input.size}")})
            case "bar" => Extern<DummyRT>.ExternPayload({input: String => "function call with input ${input}"})
            case "baz" => 
                let f : (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> =
                    {arg1: Extern<DummyRT>,  arg2: Extern<DummyRT> =>
                        let s1 = (externPayload(arg1) as String).getOrThrow()
                        let s2 = (externPayload(arg2) as String).getOrThrow()
                        return Extern<DummyRT>.ExternPayload("function call with input ${s1} and ${s2}")}
                Extern<DummyRT>.ExternPayload(f)
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
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        match (externPayload(e)) {
            case i: Int64 => match (i) {
                case 1 => Extern<DummyRT>.ExternPayload(101)
                case _ => throw Exception("functionCall not implemented")
            }
            case f: (Array<Any>) -> Extern<DummyRT>  => f(args)
            case g: (String) -> String => Extern<DummyRT>.ExternPayload(g((args[0] as String).getOrThrow()))
            case h: (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> => h((args[0] as Extern<DummyRT>).getOrThrow(), (args[1] as Extern<DummyRT>).getOrThrow())
            case _ => throw Exception("functionCall not implemented")
        }
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<Float64> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<Rune> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<UInt32> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<Int32> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<HashMap<String, Array<Int64>>> => (externPayload(eval(h)) as R).getOrThrow()
            case _: Option<String> => (externPayload(eval(h)) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let e1 = Extern<DummyRT>.ExternPayload(1)
    if (DummyRT.fromExtern<Int64>(e1()) != 101) {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<Int64>(e1.id()) != 101) {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<Int64>(e1.id.id.id.id()) != 101) {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<Int64>(e1.id.id.id.id.sub.add()) != 101) {
        throw Exception("test failed")
    }

    let m: HashMap<String, Array<Int64>> = HashMap<String, Array<Int64>>()
    let e2 = Extern<DummyRT>.ExternPayload(m)
    m["one"] = [1, 2, 3]
    if (DummyRT.fromExtern<Int64>(e2["one"][0].id()) != 101) {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<Int64>(e2.id["one"].id[0]()) != 101) {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<String>(e2.foo()) != "function call with input size 0") {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<String>(e2.foo(1, 2, 3)) != "function call with input size 3") {
        throw Exception("test failed")
    }

    if (DummyRT.fromExtern<String>(e2.bar("hello")) != "function call with input hello") {
        throw Exception("test failed")
    }

    let e3 = Extern<DummyRT>.ExternPayload("one")
    let e4 = Extern<DummyRT>.ExternPayload("two") 
    if (DummyRT.fromExtern<String>(e2.baz(e3, e4)) != "function call with input one and two") {
        throw Exception("test failed")
    }
    0
}