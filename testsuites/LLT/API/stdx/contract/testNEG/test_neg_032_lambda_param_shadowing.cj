/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-032: a function-level auxiliary variable is rewritten by name at token
// level, so a lambda parameter with the same name would be corrupted into
// `contractGhostGet(...): T =>` and crash the macro expansion (audit 16.18).
// The validation layer reports the shadowing instead.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract variable `total` is shadowed by a local declaration
// ASSERT: scan-not core dumped
// ASSERT: scan-not ParseASTException

import stdx.contract.macros.*

@Contract
class Neg032LambdaParamShadow {
    @Contract[variable total: Int64 = 0]
    public func f(): Int64 {
        let g = { total: Int64 => total * 2 }
        @ghost ( total = 3 )
        return g(2)
    }
}

main() {
}
