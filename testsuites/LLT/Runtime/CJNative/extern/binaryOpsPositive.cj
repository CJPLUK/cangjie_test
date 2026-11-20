// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Operators with an Extern left operand produce Extern results through dynamic member calls:
// `e op v` is desugared into `T.functionCall(T.memberAccess(e, "op"), [v])`. Check both the
// operation performed by the call and its numerical result. Parenthesized intermediate
// operations are evaluated before the outer call. Ordinary Cangjie operands are passed
// directly, without toExtern conversions.

var lastTree: String = ""
var evaluations: Int64 = 0

/** The operator `op` looked up on the value `lhs`, ready to be called. */
class BoundOperator {
    BoundOperator(let lhs: Int64, let op: String) {}
}

func operand(value: Any): Int64 {
    match (value) {
        case e: Extern<ArithmeticRT> => operand(Extern.getPayload(e))
        case i: Int64 => i
        case _ => throw Exception("unexpected operand type")
    }
}

func apply(lhs: Int64, op: String, args: Array<Any>): Int64 {
    if (args.size == 0 && op == "-") {
        return -lhs
    }
    if (args.size != 1) {
        throw Exception("expected one binary operand")
    }
    let rhs = operand(args[0])
    match (op) {
        case "+" => lhs + rhs
        case "-" => lhs - rhs
        case "*" => lhs * rhs
        case "/" => lhs / rhs
        case "%" => lhs % rhs
        case _ => throw Exception("unexpected operator: " + op)
    }
}

class ArithmeticRT <: ForeignRuntime<ArithmeticRT> {
    public static func memberAccess(e: Extern<ArithmeticRT>, field: String): Extern<ArithmeticRT> {
        Extern<ArithmeticRT>(BoundOperator(operand(e), field))
    }

    public static func indexedAccess(e: Extern<ArithmeticRT>, arg: Any): Extern<ArithmeticRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<ArithmeticRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<ArithmeticRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<ArithmeticRT>, args: Array<Any>): Extern<ArithmeticRT> {
        let callee = (Extern.getPayload(e) as BoundOperator).getOrThrow()
        evaluations++
        lastTree = "${callee.lhs}.${callee.op}(" +
            String.join(Array<String>(args.size, {i => operand(args[i]).toString()}), delimiter: ", ") + ")"
        Extern<ArithmeticRT>(apply(callee.lhs, callee.op, args))
    }

    public static func fromExtern<U>(value: Extern<ArithmeticRT>): U {
        (Extern.getPayload(value) as U).getOrThrow()
    }

    public static func toExtern<U>(_: U): Extern<ArithmeticRT> {
        throw Exception("operator operands must not be implicitly converted")
    }
}

func add<T>(e: Extern<T>, value: Int64): Extern<T> where T <: ForeignRuntime<T> {
    e + value
}

func check(actual: Extern<ArithmeticRT>, expected: Int64, tree: String, expectedEvaluations!: Int64 = 1): Unit {
    let value = ArithmeticRT.fromExtern<Int64>(actual)
    if (value != expected || lastTree != tree || evaluations != expectedEvaluations) {
        throw Exception("expected ${tree} = ${expected} with ${expectedEvaluations} evaluations; got ${lastTree} = ${value} with ${evaluations}")
    }
    evaluations = 0
}

main() {
    let e = Extern<ArithmeticRT>(10)
    let other = Extern<ArithmeticRT>(3)

    let sum: Extern<ArithmeticRT> = e + 1
    check(sum, 11, "10.+(1)")
    check(e + other, 13, "10.+(3)")
    check(e + (1 + 2), 13, "10.+(3)")
    check((e + 1) + other, 14, "11.+(3)", expectedEvaluations: 2)
    check(e + (other + 2), 15, "10.+(5)", expectedEvaluations: 2)
    check(add<ArithmeticRT>(e, 2), 12, "10.+(2)")

    check(e - 2, 8, "10.-(2)")
    check(e * other, 30, "10.*(3)")
    check(e / 2, 5, "10./(2)")
    check(e % other, 1, "10.%(3)")
    check(-e, -10, "10.-()")
    0
}
