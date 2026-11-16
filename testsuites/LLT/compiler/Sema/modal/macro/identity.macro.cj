// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package identity_macro

internal import std.ast.*

public macro Identity(input: Tokens): Tokens {
    input
}

// `@local` is a legal macro name as well as a mode. Same identity, required by that call site.
public macro local(input: Tokens): Tokens {
    input
}
