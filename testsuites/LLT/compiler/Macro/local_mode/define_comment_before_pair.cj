// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Mode-pair recognition across a comment between '@' and the pair in emitted
// tokens: '@ /*c*/ local!'. The emitted stream carries a COMMENT between '@'
// and the mode pair. Macro-side IsModalAfterAt treats NL/COMMENT as skippable
// and the parser-side re-parse never observes COMMENT tokens
// (ParserImpl::Peek unconditionally filters them, LookAheadSkipNL skips them
// on both cache and scan paths), so the pair matches end-to-end. See
// emitted_comment_before_modal.cj for the consuming case.

macro package define

internal import std.ast.*

public macro M(_: Tokens): Tokens {
    quote(
        func count(): Int64 {
            let n: Int64 @ /*c*/ local! = 42
            let m: Int64 = n
            return n + m
        }
    )
}
