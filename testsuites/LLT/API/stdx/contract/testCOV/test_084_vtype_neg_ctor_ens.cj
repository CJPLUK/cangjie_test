/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-084: a constructor contract cannot carry an `ensures`
// return binding; expansion must report the targeted diagnostic and keep the
// original declaration.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan return binding is not supported on constructor contracts
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class VCovNegCtorEns {
    @Contract [ ensures r: r > 0 ]
    VCovNegCtorEns(n: Int64) {}
}

main() {
}
