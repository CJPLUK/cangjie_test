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

class Boxed {
    Boxed(public var value: Any) {}
}

var countIncs: Int64 = 0
var countAdds: Int64 = 0

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
            case "inc" => 
                countIncs = countIncs + 1
                let e = (externPayload(e) as Boxed).getOrThrow()
                Extern<DummyRT>.ExternPayload(Boxed((e.value as Int64).getOrThrow() + 1))
            case _ => throw ExternMemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexedAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexedAccess not implemented")
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any) : Unit  {
        match (field) {
            case "add" => 
                countAdds = countAdds + 1
                let v = (externPayload(e) as Boxed).getOrThrow()
                v.value =  (v.value as Int64).getOrThrow() + (value as Int64).getOrThrow()
            case "set" => 
                let v = (externPayload(e) as Boxed).getOrThrow()
                v.value = value
            case "mutate" => 
                let v = (externPayload(e) as Boxed).getOrThrow()
                let s = (v.value as String).getOrThrow()
                let c = (value as Rune).getOrThrow()
                v.value = String([c]) + s[1..]
            case _ => throw ExternMemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexedUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => ((externPayload(eval(e)) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<String>  => ((externPayload(eval(e)) as Boxed).getOrThrow().value as R).getOrThrow()
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let e1 = Extern<DummyRT>.ExternPayload(Boxed(0))
    e1.add = 10

    if (DummyRT.fromExtern<Int64>(e1) != 10) {
        throw Exception("test failed")
    }

    e1.set = 20
    if (DummyRT.fromExtern<Int64>(e1) != 20) {
        throw Exception("test failed")
    }

    e1.add = 1
    if (DummyRT.fromExtern<Int64>(e1) != 21) {
        throw Exception("test failed")
    }

    e1.set = "hello"
    if (DummyRT.fromExtern<String>(e1) != "hello") {
        throw Exception("test failed")
    }

    e1.mutate = r'a'
    if (DummyRT.fromExtern<String>(e1) != "aello") {
        throw Exception("test failed")
    }

    let e2 = Extern<DummyRT>.ExternPayload(Boxed(0))

    let currentCountIncs = countIncs
    let currentCountAdds = countAdds
    
    e2.inc.inc.inc.inc.inc.add = 10
    
    if (DummyRT.fromExtern<Int64>(e2) != 0) {
        throw Exception("test failed")
    }

    if (countIncs - currentCountIncs != 5) {
        throw Exception("test failed")
    }

    if (countAdds - currentCountAdds != 1) {
        throw Exception("test failed")
    }

    0
}