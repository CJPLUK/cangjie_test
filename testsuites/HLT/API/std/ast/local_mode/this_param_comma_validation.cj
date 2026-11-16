// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt -O2 %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.ast.*

func check(condition: Bool, message: String): Unit {
    if (!condition) { throw Exception(message) }
}

func rejectComma(node: ThisParam, invalid: Token): Unit {
    let original = node.comma
    var rejected = false
    try { node.comma = invalid }
    catch (error: ASTException) {
        rejected = true
        check(error.message == "Illegal token kind: expected '${TokenKind.COMMA}', got '${invalid.kind}'.",
            "comma must use the common token diagnostic")
    }
    check(rejected, "wrong comma kind must be rejected")
    check(node.comma == original, "rejected assignment must retain the previous comma")
}

main(): Int64 {
    let node = ThisParam()
    let comma = Token(TokenKind.COMMA).addPosition(1, 2, 3)
    node.comma = comma
    check(node.comma == comma, "valid comma and position")
    rejectComma(node, Token(TokenKind.IDENTIFIER, "value"))
    rejectComma(node, Token(TokenKind.ADD))
    rejectComma(node, Token())
    println("ThisParam comma validation passed")
    0
}
