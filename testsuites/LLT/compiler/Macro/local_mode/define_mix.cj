// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Discrimination case: M's output contains BOTH a nested macro call '@N' and a
// modal '@local!'. HasMacroCallToEval must evaluate the former and skip the
// latter, so IsModalAfterAt must not mistake '@local' for a call to a macro
// named 'local' (and vice versa). N passes its input through unchanged, so the
// modal survives into the final program and must still be glued on re-parse.
public macro M(_: Tokens): Tokens {
    quote(
        @N
        func gen(): Int64 {
            let n: Int64 @local! = 42
            return n
        }
    )
}

public macro N(input: Tokens): Tokens {
    return input
}
