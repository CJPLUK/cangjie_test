/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-035: an accessor label with no clauses (`@Contract[get]`, `@Contract[get {}]`)
// used to expand to a silent no-op — zero diagnostics, zero wrapping — while the
// function side rejects empty conditions. The parser now reports the missing clause
// (audit 16.21).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan expected at least one contract clause after `get`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class Neg035EmptyAccessorContract {
    private var v: Int64 = 1

    @Contract[get]
    public prop p: Int64 {
        get() { v }
    }
}

main() {
}
