// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package macrob

import std.ast.*
import liba.*

public macro MacroB(input: Tokens): Tokens {
    let msg = libAHello()
    return quote(
        println($(msg))
        $(input)
    )
}
