// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_pair_gap_quote.cj
// EXEC: %compiler %cmp_macro define_pair_gap_quote.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output %run_opt

// Policy pin for refreshNewTokensPosition / CheckAddSpace: the emitted modal
// candidate carries a REAL column gap inside the pair ('@ local !'), yet the
// macro pipeline glues it into '@local!' by shape alone. This is intended:
// macro-emitted token positions are untrusted by policy (reEval passes
// requireAdjacent=false to IsModalAfterAt), so spacing inside an emitted
// stream carries no semantics. Spacing stays semantic only at source level,
// where the same shape is rejected (macro_arg_spaced_modal_illegal.cj).
// A pair-adjacent quote without any gap is pinned by define_spaced_quote.cj.

import define.*

@M
func dummy() {}

main() {}
