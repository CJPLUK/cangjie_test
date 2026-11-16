// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan -block: Block
// ASSERT: scan ExclaveExpr block roundtrip passed

import std.ast.*

func check(condition: Bool, message: String): Unit {
    if (!condition) { throw Exception(message) }
}

func tokenText(tokens: Tokens): String {
    var text = ""
    for (token in tokens) {
        if (token.kind != TokenKind.NL) { text += token.value }
    }
    text
}

class BlockCounter <: Visitor {
    public var blocks: Int64 = 0
    public override func visit(_: Block): Unit { blocks++ }
}

main(): Int64 {
    let expression = ExclaveExpr(cangjieLex("exclave { 1 }"))
    check(tokenText(expression.block.toTokens()) == "{1}", "block getter")
    let replacement = ExclaveExpr(cangjieLex("exclave { 2 }")).block
    expression.block = replacement
    check(tokenText(expression.toTokens()) == "exclave{2}", "block setter updates expression tokens")
    let roundtrip = ExclaveExpr(expression.toTokens())
    check(tokenText(roundtrip.block.toTokens()) == "{2}", "parsed block roundtrip")
    let visitor = BlockCounter()
    roundtrip.traverse(visitor)
    check(visitor.blocks == 1, "visitor traverses the replacement block exactly once")
    roundtrip.dump()
    println("ExclaveExpr block roundtrip passed")
    0
}
