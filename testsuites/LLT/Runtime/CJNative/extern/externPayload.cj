// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %output


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
        throw Exception("memberAccess not implemented") 
    }
    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw Exception("indexedAccess not implemented")
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw Exception("indexedUpdate not implemented")
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        throw Exception("fromExtern not implemented")
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    var e = Extern<DummyRT>.ExternPayload(1)
    var payload = externPayload(e)
    println((payload as Int64).getOrThrow())
    if ((payload as Int64).getOrThrow() != 1) {
        throw Exception("payload is not 1")
    }

    e = Extern<DummyRT>.ExternPayload("hello world")
    payload = externPayload(e)
    println((payload as String).getOrThrow())
    if ((payload as String).getOrThrow() != "hello world") {
        throw Exception("payload is not hello world")
    }

    e = Extern<DummyRT>.ExternPayload(true)
    payload = externPayload(e)
    println((payload as Bool).getOrThrow())
    if ((payload as Bool).getOrThrow() != true) {
        throw Exception("payload is not true")
    }

    e = Extern<DummyRT>.ExternPayload(42.0)
    payload = externPayload(e)
    println((payload as Float64).getOrThrow())
    if ((payload as Float64).getOrThrow() != 42.0) {
        throw Exception("payload is not 42.0")
    }

    let a: Array<Int64> = [1, 2, 3]
    e = Extern<DummyRT>.ExternPayload(a)
    payload = externPayload(e)
    println((payload as Array<Int64>).getOrThrow())
    if ((payload as Array<Int64>).getOrThrow() != a) {
        throw Exception("payload is not a")
    }

    0
}