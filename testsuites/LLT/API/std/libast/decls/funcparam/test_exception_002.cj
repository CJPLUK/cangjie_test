/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %coverage_opt %cmp_opt_chir2hlir %f -o %output
// RUN-EXEC: %run %run_opt %output

internal import std.ast.*

main(): Int64 {
    var cnt = 0

    // The input is embedded into 'foo($(inputs)){}'; all input tokens must be
    // consumed by the dummy decl. Nothing may be silently dropped.

    // Positive: ordinary params and member params ('let'/'var') still parse.
    try {
        let p = FuncParam(quote(x: Int64))
        if (p.identifier.value == "x") {
            cnt++
        }
    } catch (_: Exception) {
        return -1
    }
    try {
        let p = FuncParam(quote(var x: Int64))
        if (p.isMemberParam() && p.identifier.value == "x") {
            cnt++
        }
    } catch (_: Exception) {
        return -1
    }
    try {
        let p = FuncParam(quote(let x: Int64))
        if (p.isMemberParam() && p.identifier.value == "x") {
            cnt++
        }
    } catch (_: Exception) {
        return -1
    }

    // Negative: 'x: Int64) {} func evil() {}' — the dummy decl closes early and
    // the trailing tokens must not be silently dropped.
    let trailingJunk = Tokens()
        .append(quote(x: Int64))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LCURL))
        .append(Token(TokenKind.RCURL))
        .append(quote(func evil() {}))
    try {
        FuncParam(trailingJunk)
    } catch (e: ASTException) {
        cnt++
    }

    // Negative: 'x: Int64)(y: Int64' — a second (curried) param list is not
    // supported by the grammar and must not be silently dropped.
    let secondParamList = Tokens()
        .append(quote(x: Int64))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LPAREN))
        .append(quote(y: Int64))
    try {
        FuncParam(secondParamList)
    } catch (e: ASTException) {
        cnt++
    }

    // Positive: macro-expansion params ('@M a: Int64') still parse; the macro
    // layer is peeled off into annotations and the inner param fields are kept.
    try {
        let p = FuncParam(quote(@M a: Int64))
        if (p.identifier.value == "a") {
            cnt++
        }
    } catch (_: Exception) {
        return -1
    }

    // Negative: '@M a: Int64) {}' — trailing tokens after the early-closed dummy
    // decl must not be silently dropped, with and without a macro prefix.
    let macroJunkSuffix = Tokens()
        .append(quote(@M a: Int64))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LCURL))
        .append(Token(TokenKind.RCURL))
    try {
        FuncParam(macroJunkSuffix)
    } catch (e: ASTException) {
        if (e.message == "Cannot construct the 'FuncParam' node.") {
            cnt++
        }
    }
    let plainJunkSuffix = Tokens()
        .append(quote(a: Int64))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LCURL))
        .append(Token(TokenKind.RCURL))
    try {
        FuncParam(plainJunkSuffix)
    } catch (e: ASTException) {
        if (e.message == "Cannot construct the 'FuncParam' node.") {
            cnt++
        }
    }

    if (cnt != 8) {
        return -1
    }
    return 0
}
