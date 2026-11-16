// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package this_param_macro

internal import std.ast.*

// 重新解析输入 decl 并原样输出，覆盖 func 参数列表中 this 参数的解析路径
public macro M(input: Tokens): Tokens {
    let decl = parseDecl(input)
    return decl.toTokens()
}
