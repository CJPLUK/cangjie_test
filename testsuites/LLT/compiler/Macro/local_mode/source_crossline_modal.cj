// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// Source-side cross-line modals: the parser skips NL between '@' and the mode
// pair (SeeingModalInfo looks ahead via LookAheadSkipNL, ParseModeSpecifier
// consumes the same NL). Pins the parser half of the parity contract; the
// macro-output half of the '@\n local!=' form is covered by
// emitted_quote_spaced_modal.cj.

main() {
    let a: Int64 @
        local! = 1
    let b: Int64 @
        local? = 2
    let c: Int64 @
        ~local = 3
    println(a + b + c)
    return 0
}
