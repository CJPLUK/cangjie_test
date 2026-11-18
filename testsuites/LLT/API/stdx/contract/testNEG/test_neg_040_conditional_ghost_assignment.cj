/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-040: an auxiliary variable without an initial value must be assigned
// by an assignment that provably runs. A `@ghost` block nested in an `if` body
// may never execute, so the compile-time "never assigned" warning must stay
// (audit 16.26 — the marker used to treat the conditional assignment as a
// guaranteed one and the warning disappeared).
// EXEC-PIPE-0: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan never assigned in a constructor `@ghost` block
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable aux: Int64
]
class Neg040ConditionalGhostAssignment {
    init(flag: Bool) {
        if (flag) {
            @ghost(
                aux = 1
            )
        }
    }
}

main() {
}
