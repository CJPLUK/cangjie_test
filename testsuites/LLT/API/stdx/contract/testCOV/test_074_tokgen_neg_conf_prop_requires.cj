/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-074: a `[conforming]` override of a parent property may
// not strengthen the parent precondition, so adding a `requires` clause to the
// redeclared property is reported for the property clauses.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot add a `requires` contract
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
interface CovTokConfPropBase {
    @Contract [get requires v > 0]
    prop confProp: Int64
}

@Contract [inherits from CovTokConfPropBase [conforming]]
interface CovTokConfPropChild <: CovTokConfPropBase {
    @Contract [get requires v > 0]
    prop confProp: Int64
}

main() {
}
