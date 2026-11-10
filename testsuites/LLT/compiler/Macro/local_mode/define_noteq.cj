// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Emits '@local!= 1': the lexer merges '!' and '=' into one NOTEQ token, and
// CheckAddSpace had no rule for (IDENTIFIER, NOTEQ), so the regenerated source
// became '@local != 1' and the modal was lost on re-parse.
public macro M(_: Tokens): Tokens {
    quote(
        func cnt(): Int64 {
            var m: Int64 @local!= 1
            m = m + 1
            return m
        }
    )
}
