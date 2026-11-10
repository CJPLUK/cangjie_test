// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// Source-side comment gaps between '@' and the mode pair ('@ /*c*/ local!').
// COMMENT tokens never reach ParseModeSpecifier: ParserImpl::Peek filters
// them unconditionally and LookAheadSkipNL skips them on both cache and scan
// paths, so a comment between '@' and the pair does not break modal
// recognition — same contract as the NL case in source_crossline_modal.cj.
// Pins the source half of compiler#2375's comment-gap review point; the
// macro-output half is covered by emitted_comment_before_modal.cj.

main() {
    let a: Int64 @ /*c*/ local! = 1
    let b: Int64 @ /*c*/ local? = 2
    let c: Int64 @ /*c*/ ~local = 3
    println(a + b + c)
    return 0
}
