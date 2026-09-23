// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-8 expected 'Bool', found 'Enum-Extern<Class-DummyRT>'
// ASSERT: scan-8 error: mismatched types

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

main (){
    let e1 = Extern<DummyRT>.ExternPayload(1)
    let e2 = Extern<DummyRT>.ExternPayload(2)
    if (e1 < e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 <= e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 > e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 >= e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 - e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 + e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 == e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 != e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    0
}
