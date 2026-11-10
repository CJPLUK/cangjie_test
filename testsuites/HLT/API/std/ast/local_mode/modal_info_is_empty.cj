// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt -O2 %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.ast.*

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

func checkMode(source: String, expected: ASTMode, absent: Bool): Unit {
    let parsed = parseType(cangjieLex(source))
    let parsedModal = typeModal(parsed)
    if (parsedModal.mode != expected || parsedModal.isEmpty() != absent) {
        throw Exception("Unexpected modal state for '${source}'")
    }
    let roundtrip = parseType(parsed.toTokens())
    let roundtripModal = typeModal(roundtrip)
    if (roundtripModal.mode != expected || roundtripModal.isEmpty() != absent) {
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
