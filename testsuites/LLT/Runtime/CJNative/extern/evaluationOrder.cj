// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan update: expr1() expr2() expr3() []=
// ASSERT: scan compound: expr4() expr5() [] .+ expr6() .+() []=
// ASSERT: scan call: expr8() expr9() expr10() expr7()
// ASSERT: scan member update: expr11() .f expr12() .g=
// ASSERT: scan member compound: expr13() .f .* expr14() .*() .f=

// A dynamic expression desugars to direct calls to the functions of the foreign runtime,
// which follow the standard Cangjie evaluation order: the receiver, then the index, then
// the value; the callee, then the arguments from left to right, then the call itself.
// A compound assignment evaluates its receiver and index once, reads the current value,
// looks up the operator, evaluates the right-hand side, calls the operator and writes the
// result back. The runtime prints every operation when it performs it.

class Trace <: ForeignRuntime<Trace> {
    public static func memberAccess(e: Extern<Trace>, field: String): Extern<Trace> {
        print(" ." + field)
        Extern<Trace>("." + field)
    }

    public static func indexedAccess(e: Extern<Trace>, arg: Any): Extern<Trace> {
        print(" []")
        e
    }

    public static func memberUpdate(e: Extern<Trace>, field: String, value: Any): Unit {
        print(" ." + field + "=")
    }

    public static func indexedUpdate(e: Extern<Trace>, field: Any, value: Any): Unit {
        print(" []=")
    }

    public static func functionCall(e: Extern<Trace>, args: Array<Any>): Extern<Trace> {
        print(" " + (Extern.getPayload(e) as String).getOrThrow() + "()")
        e
    }

    public static func fromExtern<R>(_: Extern<Trace>): R {
        throw Exception("fromExtern is not used")
    }

    public static func toExtern<R>(v: R): Extern<Trace> {
        Extern<Trace>(v)
    }
}

main() {
    let expr1: Extern<Trace> = "expr1"
    let expr2: Extern<Trace> = "expr2"
    let expr3: Extern<Trace> = "expr3"
    let expr4: Extern<Trace> = "expr4"
    let expr5: Extern<Trace> = "expr5"
    let expr6: Extern<Trace> = "expr6"
    let expr7: Extern<Trace> = "expr7"
    let expr8: Extern<Trace> = "expr8"
    let expr9: Extern<Trace> = "expr9"
    let expr10: Extern<Trace> = "expr10"
    let expr11: Extern<Trace> = "expr11"
    let expr12: Extern<Trace> = "expr12"
    let expr13: Extern<Trace> = "expr13"
    let expr14: Extern<Trace> = "expr14"
    print("update:")
    expr1()[expr2()] = expr3()
    println()
    print("compound:")
    expr4()[expr5()] += expr6()
    println()
    print("call:")
    expr7(expr8(), expr9(), expr10())
    println()
    print("member update:")
    expr11().f.g = expr12()
    println()
    print("member compound:")
    expr13().f *= expr14()
    println()
    0
}
