/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-016 (implementation deviation): DT expects that after a variable is
// renamed, referencing the original name `Base.x` is a compile error. Variable
// renaming itself is not part of design v2 §3.4.1 (only `inherits invariant`
// supports renaming), so both the rename clause and the original-name clause
// are rejected at parse time with the same diagnostic. This file pins the
// original-name clause and shares the diagnostic with CT-INH-015.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan variable clause needs a name and `:` before its type
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable count: Int64 = 5
    invariant [Inv] count > 0
]
open class InhNeg016Base {
    public init() {}
}

@Contract[
    variable InhNeg016Base.count
]
class InhNeg016Sub <: InhNeg016Base {
    public init() {
        super()
    }
}

main() {
}
