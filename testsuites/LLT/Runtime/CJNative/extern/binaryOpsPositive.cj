// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Operators with an Extern left operand produce Extern results through dynamic member calls.
// Check both the operation tree and its numerical result. Parenthesized intermediate
// operations are evaluated before the outer call. Ordinary Cangjie operands are passed
// directly, without toExtern conversions.

var lastTree: String = ""
var evaluations: Int64 = 0

func showOperand(value: Any): String {
    match (value) {
        case e: Extern<ArithmeticRT> => show(e)
        case i: Int64 => i.toString()
        case _ => throw Exception("unexpected operand type")
    }
}

func show(tree: Extern<ArithmeticRT>): String {
    match (tree) {
        case ExternPayload(value) => showOperand(value)
        case ExternMemberAccess(receiver, field) => show(receiver) + "." + field
        case ExternFunctionCall(callee, args) =>
            show(callee) + "(" + String.join(Array<String>(args.size, {i => showOperand(args[i])}), delimiter: ", ") + ")"
        case _ => throw Exception("unexpected operation tree")
    }
}

func operand(value: Any): Int64 {
    match (value) {
        case e: Extern<ArithmeticRT> => evaluate(e)
        case i: Int64 => i
        case _ => throw Exception("unexpected operand type")
    }
}

func evaluate(tree: Extern<ArithmeticRT>): Int64 {
    match (tree) {
        case ExternPayload(value) => operand(value)
        case ExternFunctionCall(callee, args) =>
            match (callee) {
                case ExternMemberAccess(receiver, op) =>
                    let lhs = evaluate(receiver)
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
                case _ => throw Exception("expected an operator member call")
            }
        case _ => throw Exception("unexpected operation tree")
    }
}

class ArithmeticRT <: ForeignRuntime<ArithmeticRT> {
    public static func eval(tree: Extern<ArithmeticRT>): Extern<ArithmeticRT> {
        evaluations++
        lastTree = show(tree)
        Extern<ArithmeticRT>.ExternPayload(evaluate(tree))
    }

    public static func fromExtern<U>(value: Extern<ArithmeticRT>): U {
        match (value) {
            case ExternPayload(payload) => (payload as U).getOrThrow()
            case _ => throw Exception("expected an evaluated payload")
        }
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
    let e = Extern<ArithmeticRT>.ExternPayload(10)
    let other = Extern<ArithmeticRT>.ExternPayload(3)

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
