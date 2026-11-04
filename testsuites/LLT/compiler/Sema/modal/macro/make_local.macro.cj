// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package make_local_macro

internal import std.ast.*
internal import std.collection.*

func hasMod(mods: ArrayList<Modifier>, kind: TokenKind): Bool {
    for (x in mods) {
        if (x.keyword.kind == kind) {
            return true
        }
    }
    return false
}

// Non-local fun → exclave (unless primary ctor) + @local! on params / this / return.
func emitLocalFunc(fd: FuncDecl, isInstance: Bool, addExclave: Bool): Tokens {
    var s = ""
    for (m in fd.modifiers) {
        s = s + m.keyword.value + " "
    }
    if (addExclave && !hasMod(fd.modifiers, TokenKind.EXCLAVE)) {
        s = s + "exclave "
    }
    if (fd.keyword.value.size > 0) {
        s = s + fd.keyword.value + " "
    }
    if (fd.identifier.value.size > 0 && fd.keyword.value != fd.identifier.value) {
        s = s + fd.identifier.value
    }
    s = s + "("
    var first = true
    if (isInstance) {
        s = s + "this @local!"
        first = false
    }
    for (p in fd.funcParams) {
        if (!first) {
            s = s + ", "
        }
        first = false
        s = s + p.identifier.value + ": " + p.paramType.toTokens().toString() + " @local!"
    }
    s = s + ")"
    try {
        s = s + ": " + fd.declType.toTokens().toString() + " @local!"
    } catch (_: ASTException) {
        ()
    }
    s = s + " " + fd.block.toTokens().toString()
    cangjieLex(s)
}

func emitPrimary(pcd: PrimaryCtorDecl): Tokens {
    // Primary ctor params desugar to fields (no modal allowed). Leave signature as-is; no exclave.
    pcd.toTokens()
}

func emitTypeBody(decls: ArrayList<Decl>): String {
    var s = ""
    for (d in decls) {
        match (d as FuncDecl) {
            case Some(fd) =>
                if (!fd.modal.isEmpty()) {
                    s = s + fd.toTokens().toString() + "\n"
                } else {
                    let isInst = !hasMod(fd.modifiers, TokenKind.STATIC)
                    s = s + emitLocalFunc(fd, isInst, true).toString() + "\n"
                }
            case None =>
                match (d as PrimaryCtorDecl) {
                    case Some(pcd) => s = s + emitPrimary(pcd).toString() + "\n"
                    case None => s = s + d.toTokens().toString() + "\n"
                }
        }
    }
    s
}

public macro MakeLocal(input: Tokens): Tokens {
    let decl = parseDecl(input)
    match (decl as ClassDecl) {
        case Some(cd) =>
            return cangjieLex("class " + cd.identifier.value + " {\n" + emitTypeBody(cd.body.decls) + "}\n")
        case None => ()
    }
    match (decl as StructDecl) {
        case Some(sd) =>
            return cangjieLex("struct " + sd.identifier.value + " {\n" + emitTypeBody(sd.body.decls) + "}\n")
        case None => ()
    }
    match (decl as FuncDecl) {
        case Some(fd) =>
            let isInstance = fd.keyword.kind == TokenKind.INIT || fd.thisParam.isSome()
            return emitLocalFunc(fd, isInstance, true)
        case None => ()
    }
    match (decl as PrimaryCtorDecl) {
        case Some(pcd) => return emitPrimary(pcd)
        case None => ()
    }
    decl.toTokens()
}
