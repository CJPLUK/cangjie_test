/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-049: malformed clause shapes: `inherits` without `from`, a label
// without a condition, a clause without an expression, an empty `get` block,
// trailing tokens after a property contract clause, and an empty
// `@contractAssert`.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `inherits` clause needs `from` or `invariant`
// ASSERT: scan contract clause label must be followed by a condition expression
// ASSERT: scan contract clause needs an expression
// ASSERT: scan expected at least one contract clause after `get`
// ASSERT: scan contractAssert needs at least one assertion expression
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [ inherits CovNegParseBase ]
class CovNegNoFrom {
    public init() {}
}

@Contract [ requires [lbl] ]
func covNegLabelOnly(): Int64 {
    1
}

@Contract [ requires ]
func covNegEmptyClause(): Int64 {
    1
}

class CovNegPropHost {
    public init() {}

    @Contract [ get { } ]
    public prop emptyGet: Int64 {
        get() { 1 }
    }
}

class CovNegPropTrail {
    public init() {}

    @Contract [ get { requires true } trailingGarbage ]
    public prop trailing: Int64 {
        get() { 1 }
    }
}

func covNegEmptyAssert(): Int64 {
    @contractAssert()
    1
}

main() {
}
