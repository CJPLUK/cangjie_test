// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Pass-through expression macro used by macro_arg_spaced_modal_illegal.cj.
public macro M(_: Tokens): Tokens {
    quote(42)
}
