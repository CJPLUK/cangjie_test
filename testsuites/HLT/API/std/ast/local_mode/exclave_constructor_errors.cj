// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt -O2 %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.ast.*

main(): Int64 {
    for (input in ["exclave {", "exclave", "exclave { let value = }", "1", ""]) {
        var rejected = false
        try { let _ = ExclaveExpr(cangjieLex(input)) }
        catch (error: ASTException) {
            rejected = true
            if (error.message != "Cannot construct the 'ExclaveExpr' node.") {
                throw Exception("Unexpected constructor diagnostic: ${error.message}")
            }
        }
        if (!rejected) { throw Exception("Invalid ExclaveExpr was accepted") }
    }
    let valid = ExclaveExpr(cangjieLex("exclave { 1 }"))
    if (valid.keyword.kind != TokenKind.EXCLAVE) { return 1 }
    println("ExclaveExpr constructor errors passed")
    0
}
