// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan LeftToRight update: expr1 expr2 expr3
// ASSERT: scan LeftToRight compound: expr4 expr5 expr6
// ASSERT: scan LeftToRight call: expr7 expr8 expr9 expr10
// ASSERT: scan RightToLeft update: expr3 expr2 expr1
// ASSERT: scan RightToLeft compound: expr6 expr5 expr4
// ASSERT: scan RightToLeft call: expr10 expr9 expr8 expr7
// ASSERT: scan MiddleLeftRight update: expr2 expr1 expr3
// ASSERT: scan MiddleLeftRight compound: expr5 expr4 expr6
// ASSERT: scan MiddleLeftRight call: expr9 expr8 expr10 expr7

// A dynamic expression desugars to a single `T.eval` of one tree, so the order in which its
// operands are evaluated is defined by the foreign runtime, not by Cangjie. Each runtime
// below evaluates the operands of a node in a different order, and prints the name of the
// callee of every dynamic call when it evaluates that callee:
// - LeftToRight: receiver, index, value; callee, then arguments from left to right.
// - RightToLeft: the reverse of LeftToRight.
// - MiddleLeftRight: index, receiver, value; arguments middle, left, right, then callee.

class LeftToRight <: ForeignRuntime<LeftToRight> {
    public static func eval(t: Extern<LeftToRight>): Extern<LeftToRight> {
        match (t) {
            case ExternPayload(_) => ()
            case ExternIndexedAccess(receiver, index) => evalIndexed(receiver, index, ())
            case ExternIndexedUpdate(receiver, index, value) => evalIndexed(receiver, index, value)
            case ExternCompoundAssignment(ExternIndexedAccess(receiver, index), _, value) =>
                evalIndexed(receiver, index, value)
            case ExternFunctionCall(callee, args) =>
                evalCallee(callee)
                for (arg in args) {
                    evalOperand(arg)
                }
            case _ => throw ExternUnsupportedOperation()
        }
        t
    }

    private static func evalIndexed(receiver: Extern<LeftToRight>, index: Any, value: Any): Unit {
        eval(receiver)
        evalOperand(index)
        evalOperand(value)
    }

    private static func evalCallee(callee: Extern<LeftToRight>): Unit {
        match (callee) {
            case ExternPayload(name) => print(" " + (name as String).getOrThrow())
            case _ => eval(callee)
        }
    }

    private static func evalOperand(operand: Any): Unit {
        match (operand) {
            case e: Extern<LeftToRight> => eval(e)
            case _ => ()
        }
    }

    public static func fromExtern<R>(_: Extern<LeftToRight>): R {
        throw Exception("fromExtern is not used")
    }

    public static func toExtern<R>(v: R): Extern<LeftToRight> {
        Extern<LeftToRight>.ExternPayload(v)
    }
}

class RightToLeft <: ForeignRuntime<RightToLeft> {
    public static func eval(t: Extern<RightToLeft>): Extern<RightToLeft> {
        match (t) {
            case ExternPayload(_) => ()
            case ExternIndexedAccess(receiver, index) => evalIndexed(receiver, index, ())
            case ExternIndexedUpdate(receiver, index, value) => evalIndexed(receiver, index, value)
            case ExternCompoundAssignment(ExternIndexedAccess(receiver, index), _, value) =>
                evalIndexed(receiver, index, value)
            case ExternFunctionCall(callee, args) =>
                for (i in args.size - 1..=0 : -1) {
                    evalOperand(args[i])
                }
                evalCallee(callee)
            case _ => throw ExternUnsupportedOperation()
        }
        t
    }

    private static func evalIndexed(receiver: Extern<RightToLeft>, index: Any, value: Any): Unit {
        evalOperand(value)
        evalOperand(index)
        eval(receiver)
    }

    private static func evalCallee(callee: Extern<RightToLeft>): Unit {
        match (callee) {
            case ExternPayload(name) => print(" " + (name as String).getOrThrow())
            case _ => eval(callee)
        }
    }

    private static func evalOperand(operand: Any): Unit {
        match (operand) {
            case e: Extern<RightToLeft> => eval(e)
            case _ => ()
        }
    }

    public static func fromExtern<R>(_: Extern<RightToLeft>): R {
        throw Exception("fromExtern is not used")
    }

    public static func toExtern<R>(v: R): Extern<RightToLeft> {
        Extern<RightToLeft>.ExternPayload(v)
    }
}

class MiddleLeftRight <: ForeignRuntime<MiddleLeftRight> {
    public static func eval(t: Extern<MiddleLeftRight>): Extern<MiddleLeftRight> {
        match (t) {
            case ExternPayload(_) => ()
            case ExternIndexedAccess(receiver, index) => evalIndexed(receiver, index, ())
            case ExternIndexedUpdate(receiver, index, value) => evalIndexed(receiver, index, value)
            case ExternCompoundAssignment(ExternIndexedAccess(receiver, index), _, value) =>
                evalIndexed(receiver, index, value)
            case ExternFunctionCall(callee, args) =>
                let middle = args.size / 2
                if (args.size > 0) {
                    evalOperand(args[middle])
                }
                for (i in 0..args.size where i != middle) {
                    evalOperand(args[i])
                }
                evalCallee(callee)
            case _ => throw ExternUnsupportedOperation()
        }
        t
    }

    private static func evalIndexed(receiver: Extern<MiddleLeftRight>, index: Any, value: Any): Unit {
        evalOperand(index)
        eval(receiver)
        evalOperand(value)
    }

    private static func evalCallee(callee: Extern<MiddleLeftRight>): Unit {
        match (callee) {
            case ExternPayload(name) => print(" " + (name as String).getOrThrow())
            case _ => eval(callee)
        }
    }

    private static func evalOperand(operand: Any): Unit {
        match (operand) {
            case e: Extern<MiddleLeftRight> => eval(e)
            case _ => ()
        }
    }

    public static func fromExtern<R>(_: Extern<MiddleLeftRight>): R {
        throw Exception("fromExtern is not used")
    }

    public static func toExtern<R>(v: R): Extern<MiddleLeftRight> {
        Extern<MiddleLeftRight>.ExternPayload(v)
    }
}

func testLeftToRight(): Unit {
    let expr1: Extern<LeftToRight> = "expr1"
    let expr2: Extern<LeftToRight> = "expr2"
    let expr3: Extern<LeftToRight> = "expr3"
    let expr4: Extern<LeftToRight> = "expr4"
    let expr5: Extern<LeftToRight> = "expr5"
    let expr6: Extern<LeftToRight> = "expr6"
    let expr7: Extern<LeftToRight> = "expr7"
    let expr8: Extern<LeftToRight> = "expr8"
    let expr9: Extern<LeftToRight> = "expr9"
    let expr10: Extern<LeftToRight> = "expr10"
    print("LeftToRight update:")
    expr1()[expr2()] = expr3()
    println()
    print("LeftToRight compound:")
    expr4()[expr5()] += expr6()
    println()
    print("LeftToRight call:")
    expr7(expr8(), expr9(), expr10())
    println()
}

func testRightToLeft(): Unit {
    let expr1: Extern<RightToLeft> = "expr1"
    let expr2: Extern<RightToLeft> = "expr2"
    let expr3: Extern<RightToLeft> = "expr3"
    let expr4: Extern<RightToLeft> = "expr4"
    let expr5: Extern<RightToLeft> = "expr5"
    let expr6: Extern<RightToLeft> = "expr6"
    let expr7: Extern<RightToLeft> = "expr7"
    let expr8: Extern<RightToLeft> = "expr8"
    let expr9: Extern<RightToLeft> = "expr9"
    let expr10: Extern<RightToLeft> = "expr10"
    print("RightToLeft update:")
    expr1()[expr2()] = expr3()
    println()
    print("RightToLeft compound:")
    expr4()[expr5()] += expr6()
    println()
    print("RightToLeft call:")
    expr7(expr8(), expr9(), expr10())
    println()
}

func testMiddleLeftRight(): Unit {
    let expr1: Extern<MiddleLeftRight> = "expr1"
    let expr2: Extern<MiddleLeftRight> = "expr2"
    let expr3: Extern<MiddleLeftRight> = "expr3"
    let expr4: Extern<MiddleLeftRight> = "expr4"
    let expr5: Extern<MiddleLeftRight> = "expr5"
    let expr6: Extern<MiddleLeftRight> = "expr6"
    let expr7: Extern<MiddleLeftRight> = "expr7"
    let expr8: Extern<MiddleLeftRight> = "expr8"
    let expr9: Extern<MiddleLeftRight> = "expr9"
    let expr10: Extern<MiddleLeftRight> = "expr10"
    print("MiddleLeftRight update:")
    expr1()[expr2()] = expr3()
    println()
    print("MiddleLeftRight compound:")
    expr4()[expr5()] += expr6()
    println()
    print("MiddleLeftRight call:")
    expr7(expr8(), expr9(), expr10())
    println()
}

main() {
    testLeftToRight()
    testRightToLeft()
    testMiddleLeftRight()
    0
}
