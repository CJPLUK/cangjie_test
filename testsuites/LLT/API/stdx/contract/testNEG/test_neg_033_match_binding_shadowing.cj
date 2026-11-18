/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-033: a `match` case binding with the same name as a function-level
// auxiliary variable is rewritten by the token-level auxiliary rewrite and
// corrupts the pattern (audit 16.18, match variant). The validation layer
// reports the shadowing instead.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract variable `idx` is shadowed by a local declaration
// ASSERT: scan-not core dumped
// ASSERT: scan-not ParseASTException

import stdx.contract.macros.*

@Contract
class Neg033MatchBindingShadow {
    @Contract[variable idx: Int64 = 0]
    public func m(x: Int64): Int64 {
        match (x) {
            case idx => return 1
            case _ => return 0
        }
    }
}

main() {
}
