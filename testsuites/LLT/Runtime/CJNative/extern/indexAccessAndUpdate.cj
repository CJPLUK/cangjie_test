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

class DummyRT <: ForeignRuntime<DummyRT> {
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

    public static func memberAccess(e: Extern<DummyRT>, _: String): Extern<DummyRT> {
        return e
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        let idx = (arg as Int64).getOrThrow()
        match (externPayload(e)) {
            case a: Array<Array<Array<String>>> => a[idx]
            case a: Array<Array<String>> => a[idx]
            case a: Array<String> => a[idx]
            case _ => throw Exception("unexpected!")
        }
    }

    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any): Unit {
    }

    public static func indexedUpdate(e: Extern<DummyRT>, index: Any, value: Any): Unit {
        let idx = (index as Int64).getOrThrow()
        match (externPayload(e)) {
            case a: Array<Array<Array<String>>> => a[idx] = (value as Array<Array<String>>).getOrThrow()
            case a: Array<Array<String>> => a[idx] = (value as Array<String>).getOrThrow()
            case a: Array<String> => a[idx] = (value as String).getOrThrow()
            case _ => throw Exception("unexpected!")
        }
    }

    public static func functionCall(e: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        return e
    }

    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        return (externPayload(eval(h)) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        return Extern<DummyRT>.ExternPayload(v)
    }
}

func assert(condition: Bool, message: String) {
    if (!condition) {
        throw Exception(message)
    }
}

main () {
    let a: Array<Array<Array<String>>> = [[["000","001","002"],
                                           ["010","011","012"],
                                           ["020","021","022"]],
                                          [["100","101","102"],
                                           ["110","111","112"],
                                           ["120","121","122"]],
                                          [["200","201","202"],
                                           ["210","211","212"],
                                           ["220","221","222"]]]
    let e = Extern<DummyRT>.ExternPayload(a)


    for (i in 0..3) {
        for (j in 0..3) {
            for (k in 0..3) {
                assert(DummyRT.fromExtern<String>(e[i][j][k]) == "${i}${j}${k}", "e[${i}][${j}][${k}] is not ${i}${j}${k}")
            }
        }
    }

    for (i in 0..3) {
        for (j in 0..3) {
            for (k in 0..3) {
                assert(DummyRT.fromExtern<String>(e[i,j,k]) == "${i}${j}${k}", "e[${i},${j},${k}] is not ${i}${j}${k}")
            }
        }
    }

    for (i in 0..3) {
        for (j in 0..3) {
            for (k in 0..3) {
                e[i][j][k] = "foo${i}${j}${k}"
            }
        }
    }

    for (i in 0..3) {
        for (j in 0..3) {
            for (k in 0..3) {
                assert(DummyRT.fromExtern<String>(e[i][j][k]) == "foo${i}${j}${k}", "e[${i}][${j}][${k}] is not foo${i}${j}${k}")
            }
        }
    }

    for (i in 0..3) {
        for (j in 0..3) {
            for (k in 0..3) {
                e[i,j,k] = "bar${i}${j}${k}"
            }
        }
    }

    for (i in 0..3) {
        for (j in 0..3) {
            for (k in 0..3) {
                assert(DummyRT.fromExtern<String>(e[i,j,k]) == "bar${i}${j}${k}", "e[${i},${j},${k}] is not bar${i}${j}${k}")
            }
        }
    }

}