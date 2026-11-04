// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package pkg_macro_1

import std.ast.*
import pkg_macro_0.mfunc_920834

public macro mfunc_920835(attr: Tokens, input: Tokens): Tokens {
    return @mfunc_920834[cfg](input)
}

public macro mfunc_920836(input: Tokens): Tokens {
    return @mfunc_920834[cfg](input)
}

public macro mfunc_920837(attr: Tokens, input: Tokens): Tokens {
    return @mfunc_920834[cfg](input)
}

public macro mfunc_920838(input: Tokens): Tokens {
    return @mfunc_920834[cfg](input)
}
