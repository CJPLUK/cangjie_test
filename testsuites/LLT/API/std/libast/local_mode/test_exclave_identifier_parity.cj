// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %cmp_opt_chir2hlir %f -o %output
// EXEC: %run %run_opt %output %run_args

// Guard the local_mode_api=off build (CANGJIE_ENABLE_LOCAL_MODE_API=OFF) and
// OHOS: whenever the lexer reports "exclave"/"demode" as plain identifiers,
// libast must keep the pre-exclave-keyword behavior.
//   * cangjieLex("exclave") must yield an IDENTIFIER token, never an ILLEGAL
//     one (native local mode leaking into the trimmed TokenKind table);
//   * parseExpr(quote(exclave + 1)) must parse as an ordinary binary
//     expression and round-trip to the source text.
// This file is compiled without --enable-local-mode so that quote() captures
// "exclave" as an identifier, exactly like sources written before the keyword
// existed. The local_mode_api=on build lexes it to the EXCLAVE keyword, which
// must not be named here because the off build's TokenKind has no such
// constructor; it is detected through toString() and skipped instead.

import std.ast.*

func check(condition: Bool, message: String): Unit {
    if (!condition) { throw Exception(message) }
}

main(): Int64 {
    // IDENTIFIER: off build (and OHOS) with local mode kept off in the FFI;
    // EXCLAVE: on build; ILLEGAL: off build with local mode still enabled.
    let exclaveKind = cangjieLex("exclave")[0].kind.toString()
    check(exclaveKind == "IDENTIFIER" || exclaveKind == "EXCLAVE",
        "cangjieLex(\"exclave\") must lex to a representable kind, got '${exclaveKind}'")
    if (exclaveKind == "EXCLAVE") {
        println("local-mode APIs enabled: exclave is a keyword, identifier-parity checks skipped")
        return 0
    }

    let exclave = cangjieLex("exclave")
    check(exclave[0].kind == TokenKind.IDENTIFIER, "cangjieLex(\"exclave\") must lex to IDENTIFIER")
    check(exclave[0].value == "exclave", "cangjieLex(\"exclave\") must keep the value")
    let demode = cangjieLex("demode")
    check(demode[0].kind == TokenKind.IDENTIFIER, "cangjieLex(\"demode\") must lex to IDENTIFIER")
    check(demode[0].value == "demode", "cangjieLex(\"demode\") must keep the value")

    let sum = cangjieLex("exclave + 1")
    check(sum[0].kind == TokenKind.IDENTIFIER && sum[0].value == "exclave", "'exclave' must lex to IDENTIFIER")
    check(sum[1].kind == TokenKind.ADD, "'+' must lex to ADD")
    check(sum[2].kind == TokenKind.INTEGER_LITERAL && sum[2].value == "1", "'1' must lex to INTEGER_LITERAL")
    for (t in sum) {
        check(t.kind != TokenKind.ILLEGAL, "cangjieLex(\"exclave + 1\") must not produce ILLEGAL tokens")
    }

    // End-to-end through the FFI lexer and parser.
    let fromLex = parseExpr(cangjieLex("exclave + 1"))
    check(fromLex.toTokens().toString() == "exclave + 1",
        "parseExpr(cangjieLex(\"exclave + 1\")) must round-trip to the source")

    // Through quote(), the way macro code writes it.
    let expr = parseExpr(quote(exclave + 1))
    let bin = (expr as BinaryExpr).getOrThrow()
    check(bin.op.kind == TokenKind.ADD, "parseExpr(quote(exclave + 1)) must parse '+' as ADD")
    let ref = (bin.leftExpr as RefExpr).getOrThrow()
    check(ref.identifier.kind == TokenKind.IDENTIFIER, "'exclave' must parse as an identifier reference")
    check(ref.identifier.value == "exclave", "the identifier reference must keep the value")
    check(expr.toTokens().toString() == "exclave + 1",
        "parseExpr(quote(exclave + 1)) must round-trip to the source")
    println("exclave/demode identifier parity passed")
    0
}
