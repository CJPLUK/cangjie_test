// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt -O2 %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.ast.*

func checkMode(source: String, expected: ASTMode, absent: Bool): Unit {
    let parsed = parseType(cangjieLex(source))
    if (parsed.modal.mode != expected || parsed.modal.isEmpty() != absent) {
        throw Exception("Unexpected modal state for '${source}'")
    }
    let roundtrip = parseType(parsed.toTokens())
    if (roundtrip.modal.mode != expected || roundtrip.modal.isEmpty() != absent) {
        throw Exception("Modal state did not survive a token roundtrip for '${source}'")
    }
}

main(): Int64 {
    checkMode("Value", ASTMode.MODAL_NONE, true)
    checkMode("Value @~local", ASTMode.MODAL_NOT, false)
    checkMode("Value @local?", ASTMode.MODAL_HALF, false)
    checkMode("Value @local!", ASTMode.MODAL_FULL, false)
    println("ModalInfo isEmpty and local modes passed")
    0
}
