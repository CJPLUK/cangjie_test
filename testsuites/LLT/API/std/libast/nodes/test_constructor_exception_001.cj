/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */


// EXEC: %compiler %cmp_opt_chir2hlir %coverage_opt %f -o %output
// RUN-EXEC: %run %run_opt %output | compare %f

import std.ast.*
import std.collection.*

class MyVisitor <: Visitor {
    var ident: ArrayList<String> = ArrayList<String>()
    public func visit(curNode: Node) {
        println("traversed!")
        breakTraverse()
    }
}

let myVisitor = MyVisitor()

main(): Int64 {
    var cnt = 0

    try {
        let constructor = Constructor()
        constructor.typeArguments = ArrayList<TypeNode>([FuncType(), ParenType()])
        constructor.identifier = Token(IDENTIFIER, "ident")
        constructor.lParen = Token(LPAREN)
        constructor.rParen = Token(RPAREN)

        println(constructor.toTokens())
        constructor.traverse(myVisitor)

        constructor.dump()
    } catch (e: ASTException) {
        println(e.message)
        cnt++
    }

    ArrayList<Decl>([FuncDecl(quote(func a()))]).toTokens()[2].dump()
    println(ArrayList<Node>([FuncType(), VArrayType()]).toTokens().size)
    ArrayList<Annotation>([Annotation()]).toTokens()[1].dump()
    println("cnt = ${cnt}")
    return 0
}

// ASSERT: scan ident(() ->,())
// ASSERT: scan traversed!
// ASSERT: scan Constructor {
// ASSERT: scan -identifier: Token {
// ASSERT: scan value: "ident"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -typeArguments: 0, FuncType {
// ASSERT: scan -ARROW: Token {
// ASSERT: scan value: "->"
// ASSERT: scan kind: ARROW
// ASSERT: scan -returnType:   }
// ASSERT: scan -typeArguments: 1, ParenType {
// ASSERT: scan -parenthesizedType:   }
// ASSERT: scan description: l_paren, token_id: 2, token_literal_value: (
// ASSERT: scan 10
// ASSERT: scan description: identifier, token_id: 137, token_literal_value:
// ASSERT: scan cnt = 0
