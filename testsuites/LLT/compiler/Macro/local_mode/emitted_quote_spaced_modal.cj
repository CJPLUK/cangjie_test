// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_spaced_quote.cj
// EXEC: %compiler %cmp_macro define_spaced_quote.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// Macro output contains spaced modals ('@ local!=' and '@ ~local') and the
// cross-line form '@\n local!='. Before the fix the position-based adjacency
// check kept the column gap, the regenerated source became '@local != 1' /
// '@~ local' and the re-parse failed; the cross-line form was misreported by
// the macro evaluator. After the fix the modal is glued by token shape and NL
// between '@' and the pair is skipped, matching the parser.

import define.*

@M
func dummy() {}

main() {}
