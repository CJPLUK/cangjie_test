// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

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
    public static func indexedAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexedAccess not implemented")
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
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let e = Extern<DummyRT>.ExternPayload(0)

    if (DummyRT.fromExtern<Int64>(e.id) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(e.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.add) != 1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.sub) != -1) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Int64>(e.add.add.add.sub.sub.sub) != 0) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(e.add.add.add.sub.sub.sub.add.add.add.sub.sub.sub.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    try {
        DummyRT.fromExtern<Int64>(e.foo)
        throw Exception("Unexpected!")
    } catch (e: ExternMemberAccessException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(e.add.add.add.sub.sub.foo)
        throw Exception("Unexpected!")
    } catch (e: ExternMemberAccessException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(e.add.add.foo.add.sub.sub)
        throw Exception("Unexpected!")
    } catch (e: ExternMemberAccessException) {
        // Expected
    }

    func id(e: Extern<DummyRT>) {
        e
    }

    if (DummyRT.fromExtern<Float64>(id(e.add.add.add.sub.sub).sub.add.add.add.sub.sub.sub.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    if (DummyRT.fromExtern<Float64>(id(Extern<DummyRT>.ExternPayload(DummyRT.fromExtern<Int64>(e.add.add.add.sub.sub))).sub.add.add.add.sub.sub.sub.pi) != 3.14) {
        throw Exception("Unexpected!")
    }

    0
}