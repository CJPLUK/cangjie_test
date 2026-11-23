/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-EXT-009: design L817 forbids the type-level `@Contract` in front of an
// `extend` from declaring or inheriting `variable`/`invariant` clauses.
// Fixed (defect 16.14): `validateTypeContract` intercepts extend type-level
// contracts up front and reports a clean diagnostic instead of crashing in
// inheritance resolution.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan extend type-level contracts cannot declare or inherit abstract variables
// ASSERT: scan-not macro evaluation has failed
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class ExtTypeLevelHost {
    public func f(): Int64 {
        1
    }
}

@Contract[
    variable v: Int64 = 0
]
extend ExtTypeLevelHost {
}

main() {
}
