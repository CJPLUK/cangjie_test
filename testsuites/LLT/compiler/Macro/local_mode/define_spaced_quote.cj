// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Review-comment #3 scenario: the modal tokens in the macro output carry a
// real source column gap (spaced in the quote). Adjacency must be decided by
// token shape (IsModalSpecifierPair), not by the original Begin/End positions,
// otherwise the refreshed positions keep the gap and the modal is broken.
// 'r' additionally covers the cross-line form '@\n local!= 1': the parser
// accepts NL between '@' and the mode pair (LookAheadSkipNL), so the macro
// pipeline must recognize it too instead of misreporting the '@'.
public macro M(_: Tokens): Tokens {
    quote(
        func mixed(): Int64 {
            var n: Int64 @ local!= 1
            let q: Int64 @ ~local = 3
            let r: Int64 @
                local!= 5
            n = n + q + r
            return n
        }
    )
}
