// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt_chir2hlir -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// ASSERT: regex BEGIN_THIS_PARAM[\s\S]*-comma[\s\S]*kind: COMMA[\s\S]*END_THIS_PARAM
// ASSERT: regex BEGIN_EXCLAVE[\s\S]*kind: EXCLAVE[\s\S]*END_EXCLAVE
// ASSERT: scan Local-mode node APIs passed

import std.ast.*

func check(condition: Bool, message: String): Unit {
    if (!condition) { throw Exception(message) }
}

func reject(change: () -> Unit, unchanged: () -> Bool): Unit {
    var rejected = false
    try { change() }
    catch (error: ASTException) { rejected = true }
    check(rejected, "Invalid token must raise ASTException")
    check(unchanged(), "Rejected assignment must retain the previous token")
}

class LocalNodeCounter <: Visitor {
    public var exclaves: Int64 = 0
    public var thisParams: Int64 = 0
    public var modals: Int64 = 0
    public override func visit(_: ExclaveExpr): Unit { exclaves++ }
    public override func visit(_: ThisParam): Unit { thisParams++ }
    public override func visit(_: ModalInfo): Unit { modals++ }
}

func expectTokens(modal: ModalInfo, kinds: Array<TokenKind>): Unit {
    let ts = modal.toTokens()
    check(ts.size == kinds.size, "ModalInfo.toTokens must emit ${kinds.size} tokens, got ${ts.size}")
    for (i in 0..kinds.size) {
        check(ts[i].kind == kinds[i], "Unexpected token kind at ${i}: ${ts[i].kind}")
    }
}

func typeModal(t: TypeNode): ModalInfo {
    match (t) {
        case p: PrimitiveType => p.modal
        case r: RefType => r.modal
        case q: QualifiedType => q.modal
        case pt: ParenType => pt.modal
        case tt: TupleType => tt.modal
        case st: ThisType => st.modal
        case ft: PrefixType => ft.modal
        case fnt: FuncType => fnt.modal
        case vt: VArrayType => vt.modal
        case _ => throw Exception("unreachable TypeNode subtype")
    }
}

main(): Int64 {
    // --- ASTMode basics ---
    check(ASTMode.MODAL_NONE != ASTMode.MODAL_NOT, "ASTMode inequality must hold")
    check(ASTMode.MODAL_HALF.toString() == "MODAL_HALF", "ASTMode toString")

    // --- ModalInfo: mode prop, isEmpty, toTokens for all modes ---
    let full = typeModal(parseType(cangjieLex("Value @local!")))
    check(full.mode == ASTMode.MODAL_FULL && !full.isEmpty(), "FULL mode must be parsed")
    let half = typeModal(parseType(cangjieLex("Value @local?")))
    check(half.mode == ASTMode.MODAL_HALF && !half.isEmpty(), "HALF mode must be parsed")
    let notLocal = typeModal(parseType(cangjieLex("Value @~local")))
    check(notLocal.mode == ASTMode.MODAL_NOT && !notLocal.isEmpty(), "NOT mode must be parsed")

    expectTokens(full, [TokenKind.AT, TokenKind.IDENTIFIER, TokenKind.NOT])
    expectTokens(half, [TokenKind.AT, TokenKind.IDENTIFIER, TokenKind.QUEST])
    expectTokens(notLocal, [TokenKind.AT, TokenKind.BITNOT, TokenKind.IDENTIFIER])

    // ModalInfo has no public init; an empty instance is obtained from a parsed node
    let noneInfo = typeModal(parseType(cangjieLex("Value")))
    check(noneInfo.isEmpty() && noneInfo.toTokens().size == 0, "NONE modal must be empty and emit no tokens")
    noneInfo.mode = ASTMode.MODAL_HALF
    check(!noneInfo.isEmpty() && noneInfo.mode == ASTMode.MODAL_HALF, "mode prop must be writable")

    // --- ThisParam: comma prop validation, modal prop, toTokens ---
    println("BEGIN_THIS_PARAM")
    let tp = ThisParam()
    tp.modal = full
    tp.comma = Token(TokenKind.COMMA, ",").addPosition(1, 2, 12)
    let tpTokens = tp.toTokens()
    check(tpTokens.size == 5, "this + modal(3) + comma must all be emitted, got ${tpTokens.size}")
    check(tpTokens[0].kind == TokenKind.THIS && tpTokens[4].kind == TokenKind.COMMA,
        "ThisParam.toTokens must emit its own trailing comma")
    let comma = tp.comma
    reject({ => tp.comma = Token(TokenKind.COLON) }, { => tp.comma == comma })
    reject({ => tp.comma = Token() }, { => tp.comma == comma })
    let bare = ThisParam()
    bare.modal = full
    check(bare.toTokens().size == 4, "Invalid (default) comma must be skipped by toTokens")
    tp.dump()
    println("END_THIS_PARAM")

    // --- ThisParam(inputs): direct construction from tokens ---
    let parsed = ThisParam(quote(this @local!))
    check(parsed.`this`.kind == TokenKind.THIS, "parsed receiver must keep the this token")
    check(parsed.modal.mode == ASTMode.MODAL_FULL, "parsed receiver must keep MODAL_FULL")
    check(parsed.toTokens().size == 4, "receiver without comma must emit 4 tokens")
    let parsedWithComma = ThisParam(quote(this @local!,))
    check(parsedWithComma.comma.kind == TokenKind.COMMA, "trailing comma must be captured")
    check(parsedWithComma.toTokens().size == 5, "receiver with comma must emit 5 tokens")
    let parsedNoModal = ThisParam(quote(this))
    check(parsedNoModal.modal.isEmpty(), "receiver without modal must be empty")
    var threw = false
    try { let _ = ThisParam(quote(x: Int64)) } catch (e: ASTException) { threw = true }
    check(threw, "non-receiver tokens must be rejected with ASTException")
    threw = false
    try { let _ = ThisParam(quote(this, x: Int64)) } catch (e: ASTException) { threw = true }
    check(threw, "receiver followed by extra params must be rejected with ASTException")

    // --- ThisParam(inputs): payloads with junk tokens must be rejected, not truncated ---
    // 'this: T) {} func evil() {} func dummy(this: U2' — the review payload; the
    // ':' after the receiver makes the whole parse fail.
    let reviewPayload = Tokens()
        .append(quote(this: T))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LCURL))
        .append(Token(TokenKind.RCURL))
        .append(quote(func evil() {}))
        .append(quote(func dummy(this: U2)))
    threw = false
    try { let _ = ThisParam(reviewPayload) } catch (e: ASTException) { threw = true }
    check(threw, "receiver followed by ':' must be rejected with ASTException")
    // 'this) {} func evil() {} func dummy(this' — the first dummy decl closes
    // early; the trailing tokens must not be silently dropped.
    let trailingJunk = Tokens()
        .append(quote(this))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LCURL))
        .append(Token(TokenKind.RCURL))
        .append(quote(func evil() {}))
        .append(quote(func dummy(this)))
    threw = false
    try { let _ = ThisParam(trailingJunk) } catch (e: ASTException) { threw = true }
    check(threw, "trailing junk after an early-closed dummy decl must be rejected with ASTException")
    // 'this)(x: Int64' — a second (curried) param list is not supported by the
    // grammar and must not be silently dropped.
    let secondParamList = Tokens()
        .append(quote(this))
        .append(Token(TokenKind.RPAREN))
        .append(Token(TokenKind.LPAREN))
        .append(quote(x: Int64))
    threw = false
    try { let _ = ThisParam(secondParamList) } catch (e: ASTException) { threw = true }
    check(threw, "a second param list after the receiver must be rejected with ASTException")

    // --- FuncDecl.toTokens: modal + thisParam must not duplicate the comma ---
    let fn = FuncDecl(cangjieLex("func f(x: Int64): Int64 { x }"))
    fn.modal = full
    fn.thisParam = Some(tp)
    let fnTokens = fn.toTokens()
    var commas = 0
    var hasThis = false
    for (i in 0..fnTokens.size) {
        if (fnTokens[i].kind == TokenKind.COMMA) { commas++ }
        if (fnTokens[i].kind == TokenKind.THIS) { hasThis = true }
    }
    check(hasThis && commas == 1, "FuncDecl.toTokens must keep exactly one receiver comma")

    // --- ExclaveExpr: parse, props, toTokens, dump ---
    println("BEGIN_EXCLAVE")
    let ex = ExclaveExpr(cangjieLex("exclave { 0 }"))
    check(ex.keyword.kind == TokenKind.EXCLAVE, "ExclaveExpr must parse the exclave keyword")
    let blockTokens = ex.block.toTokens()
    var hasZero = false
    for (i in 0..blockTokens.size) {
        if (blockTokens[i].kind == TokenKind.INTEGER_LITERAL && blockTokens[i].value == "0") { hasZero = true }
    }
    check(hasZero, "ExclaveExpr must parse its block content")
    let roundTrip = ex.toTokens()
    check(roundTrip[0].kind == TokenKind.EXCLAVE && roundTrip.size == blockTokens.size + 1,
        "ExclaveExpr.toTokens must be keyword + block")
    let kw = Token(TokenKind.EXCLAVE, "exclave").addPosition(2, 1, 1)
    ex.keyword = kw
    check(ex.keyword == kw, "keyword prop must accept a valid EXCLAVE token")
    reject({ => ex.keyword = Token(TokenKind.IDENTIFIER, "exclave") }, { => ex.keyword == kw })
    ex.dump()
    println("END_EXCLAVE")

    // --- Traverse coverage of the new node types ---
    let counter = LocalNodeCounter()
    ex.traverse(counter)
    check(counter.exclaves == 1, "ExclaveExpr must be visited exactly once")
    fn.traverse(counter)
    check(counter.thisParams == 1, "The receiver must be visited through FuncDecl")
    check(counter.modals == 2, "The receiver modal and the function modal must both be visited")

    println("Local-mode node APIs passed")
    0
}
