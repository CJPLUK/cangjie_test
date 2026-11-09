// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt_chir2hlir -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args

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

main(): Int64 {
    let modal = parseType(cangjieLex("Value @local!")).modal
    let at = Token(TokenKind.AT).addPosition(1, 2, 3)
    modal.at = at
    check(modal.at == at, "Valid @ token and position")
    reject({ => modal.at = Token(TokenKind.IDENTIFIER, "at") }, { => modal.at == at })
    reject({ => modal.at = Token() }, { => modal.at == at })

    let local = Token(TokenKind.IDENTIFIER, "local").addPosition(1, 2, 4)
    modal.local = local
    check(modal.local == local, "Valid local identifier and position")
    reject({ => modal.local = Token(TokenKind.IDENTIFIER, "other") }, { => modal.local == local })
    reject({ => modal.local = Token(TokenKind.INT64) }, { => modal.local == local })
    reject({ => modal.local = Token() }, { => modal.local == local })

    for (marker in [Token(TokenKind.BITNOT), Token(TokenKind.NOT), Token(TokenKind.QUEST)]) {
        modal.marker = marker
        check(modal.marker == marker, "All three modal markers must be assignable")
        reject({ => modal.marker = Token(TokenKind.ADD) }, { => modal.marker == marker })
        reject({ => modal.marker = Token(TokenKind.IDENTIFIER, "!") }, { => modal.marker == marker })
        reject({ => modal.marker = Token() }, { => modal.marker == marker })
    }

    let receiver = ThisParam()
    let thisToken = Token(TokenKind.THIS).addPosition(1, 3, 1)
    receiver.`this` = thisToken
    check(receiver.`this` == thisToken, "Valid this token and position")
    reject({ => receiver.`this` = Token(TokenKind.IDENTIFIER, "this") }, { => receiver.`this` == thisToken })
    reject({ => receiver.`this` = Token(TokenKind.COMMA) }, { => receiver.`this` == thisToken })
    reject({ => receiver.`this` = Token() }, { => receiver.`this` == thisToken })
    println("Modal and receiver token validation passed")
    0
}
