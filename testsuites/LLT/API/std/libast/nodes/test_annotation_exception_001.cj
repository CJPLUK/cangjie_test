/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt_chir2hlir %coverage_opt %f -o %output
// RUN-EXEC-PIPE-0: %run %run_opt %output | compare %f

import std.ast.*
import std.collection.*

main(): Int64 {
    var cnt = 0

    try {
        Annotation()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        Annotation(Tokens().append(Token(AND)))
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation()
        annotation.at.dump()
        annotation.at = Token(OR)
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation()
        annotation.identifier = Token(OR)
        annotation.identifier.dump()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation()
        let argument = Argument()
        annotation.arguments = ArrayList<Argument>([argument])
        println(annotation.arguments.size)
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation()
        annotation.attributes = Tokens().append(Token(OR))
        annotation.attributes.dump()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation()
        annotation.condition.dump()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation(quote(@When[c != 1]))
        let annotation1 = Annotation(quote(@When[a == 0]))
        annotation.condition = annotation1.condition
        annotation.condition.dump()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation(quote(@Attribute[]))
        println(annotation.toTokens().size)
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    try {
        let annotation = Annotation(quote(@Attribute[a,b,c]))
        annotation.dump()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    println("cnt = ${cnt}")
    return 0
}

// ASSERT: scan Cannot construct the 'Annotation' node
// ASSERT: scan description: at, token_id: 51, token_literal_value: @
// ASSERT: scan Illegal token kind: expected 'AT' or 'AT_EXCLAMATION', got 'OR'.
// ASSERT: scan description: or, token_id: 17, token_literal_value: ||
// ASSERT: scan 1
// ASSERT: scan description: or, token_id: 17, token_literal_value: ||
// ASSERT: scan Current 'Annotation' node is not a 'When' annotation.
// ASSERT: scan BinaryExpr {
// ASSERT: scan -leftExpr: RefExpr {
// ASSERT: scan -identifier: Token {
// ASSERT: scan value: "a"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -op: Token {
// ASSERT: scan value: "=="
// ASSERT: scan kind: EQUAL
// ASSERT: scan -rightExpr: LitConstExpr {
// ASSERT: scan -literal: Token {
// ASSERT: scan value: "0"
// ASSERT: scan kind: INTEGER_LITERAL
// ASSERT: scan 3
// ASSERT: scan Annotation {
// ASSERT: scan -identifier: Attribute
// ASSERT: scan -attributes: 0,   a: Token {
// ASSERT: scan value: "a"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -attributes: 1,   b: Token {
// ASSERT: scan value: "b"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -attributes: 2,   c: Token {
// ASSERT: scan value: "c"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan cnt = 3
