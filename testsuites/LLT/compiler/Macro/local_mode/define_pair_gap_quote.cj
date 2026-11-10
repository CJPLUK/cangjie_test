// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Policy pin: the gap sits INSIDE the mode pair ('local' '!' separated by a
// real source column gap in the quote). Macro-emitted token positions are
// untrusted by policy — reEval passes requireAdjacent=false to IsModalAfterAt,
// and refreshNewTokensPosition glues shape-matching pairs unconditionally —
// so this quote is emitted, glued into '@local!' and accepted as a legal
// modal. The consuming case is emitted_pair_gap_modal_legal.cj. Spacing is
// semantic only in user source, where the same shape is rejected
// (macro_arg_spaced_modal_illegal.cj).
public macro M(_: Tokens): Tokens {
    quote(
        func f(): Int64 {
            var n: Int64 @ local ! = 1
            return n
        }
    )
}
