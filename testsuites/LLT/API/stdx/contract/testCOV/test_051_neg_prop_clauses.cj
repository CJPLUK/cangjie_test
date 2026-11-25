/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-051: the property-contract parser error paths: a function clause
// on a property, an empty accessor contract, an accessor contract with a
// missing closing brace, and stray tokens after an accessor contract.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan accessor contract
// ASSERT: scan expected at least one contract clause after
// ASSERT: scan is missing a closing
// ASSERT: scan unexpected tokens after property accessor contract
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class CovNpClauseKind {
    @Contract[requires true]
    public mut prop a: Int64 {
        get() {
            0
        }
        set(v) {
            v
        }
    }
}

class CovNpEmptyAccessor {
    @Contract[get {}]
    public mut prop b: Int64 {
        get() {
            0
        }
        set(v) {
            v
        }
    }
}

class CovNpMissingBrace {
    @Contract[get { ensures r > 0]
    public mut prop c: Int64 {
        get() {
            0
        }
        set(v) {
            v
        }
    }
}

class CovNpTrailingJunk {
    @Contract[get { ensures r > 0 } junk]
    public mut prop d: Int64 {
        get() {
            0
        }
        set(v) {
            v
        }
    }
}

main() {
}
