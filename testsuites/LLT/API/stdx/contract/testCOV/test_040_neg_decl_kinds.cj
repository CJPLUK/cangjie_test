/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-040: `@Contract` attached to unsupported declaration kinds (enum,
// local `let` via callable clauses, function via property clauses), a
// top-level function declaring an `inherits` clause, and an unparseable
// `@ghost` block.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan @Contract has no effect on enum declarations
// ASSERT: scan @Contract supports functions, methods, properties, classes, and structs
// ASSERT: scan expected a function contract clause, got get
// ASSERT: scan inherited function contracts require an enclosing type contract
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [ invariant true ]
enum CovNegEnum {
    A | B
}

@Contract [ requires true ]
let covNegVar: Int64 = 1

@Contract [ get { requires true } ]
func covNegFnProp(): Int64 {
    1
}

@Contract [ inherits requires CovNegAnyIface.anything ]
func covNegTopInherit(x: Int64): Int64 {
    x
}

func covNegGhostHost(): Int64 {
    @ghost ( let )
    1
}

main() {
}
