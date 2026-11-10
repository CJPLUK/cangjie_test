// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Control group: '@local?' is glued by the pre-existing QUEST rule and
// '@local!' by the pre-existing (IDENTIFIER, NOT) rule. Passes before and
// after the fix; guards against regressions of those two paths.
public macro M(_: Tokens): Tokens {
    quote(
        func probe(): Int64 {
            var k: Int64 @local? = 3
            var j: Int64 @local! = 4
            return k + j
        }
    )
}
