// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_comment_before_pair.cj
// EXEC: %compiler %cmp_macro define_comment_before_pair.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output %run_opt

// Pin: a COMMENT between '@' and the mode pair in emitted tokens
// ('@ /*c*/ local!') does NOT break modal recognition end-to-end. Macro-side
// IsModalAfterAt skips NL/COMMENT when looking for the pair; on re-parse,
// COMMENT tokens are invisible to the parser (ParserImpl::Peek filters them
// unconditionally, and LookAheadSkipNL skips them on both cache and scan
// paths), so both sides judge modal consistently. The '(and comments)' note
// in MacroCommon.cpp refers to exactly this behavior. A predicted
// fail-closed error ("pair mismatch -> '@local' treated as an unevaluated
// macro call") does not occur.

package default

import define.*

@M
func dummy() {
    0
}

main(): Int64 {
    return 0
}
