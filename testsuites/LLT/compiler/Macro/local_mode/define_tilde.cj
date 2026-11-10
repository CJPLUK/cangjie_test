// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package define

internal import std.ast.*

// Emits '@~local': CheckAddSpace must keep '~' glued to 'local' (no rule for
// (BITNOT, IDENTIFIER) before the local-mode fix), and RefreshNewTokensPos
// must not insert a column gap after '@'.
public macro M(_: Tokens): Tokens {
    quote(
        func count(): Int64 {
            let n: Int64 @~local = 42
            return n
        }
    )
}
