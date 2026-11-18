/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-NEG-042 (EXEC-PIPE-1): `@Contract` directly annotating an abstract property
// without accessor bodies reports the dedicated diagnostic. Fixed (defect 16.29;
// see contract-defects-audit.md): the macro used to fail while wrapping the
// missing accessor instead of reporting the actionable message.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan requires accessor bodies
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

interface Neg042AbstractProp {
    @Contract [get requires true]
    prop p: Int64
}

main() {
}
