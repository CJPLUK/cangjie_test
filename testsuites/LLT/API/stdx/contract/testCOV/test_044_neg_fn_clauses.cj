/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-044: the function-contract parser error paths: a bare `inherits`,
// an `inherits` clause without a member reference, a renamed `inherits
// variable`, an empty `requires`/`ensures`, a misplaced `$pre`, and a
// malformed function-level `variable` clause.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan needs a contract kind after it
// ASSERT: scan or `<new-name> = <type>.<name>`
// ASSERT: scan cannot rename the inherited auxiliary variable
// ASSERT: scan contract clause needs an expression
// ASSERT: scan only available in `ensures` clauses
// ASSERT: scan variable clause needs a name and
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[inherits]
func covNfBareInherits(): Unit {
}

@Contract[inherits requires]
func covNfInheritsNoTarget(): Unit {
}

@Contract[inherits variable x = SomeType.foo]
func covNfInheritsVariableRename(): Unit {
}

@Contract[requires]
func covNfEmptyRequires(): Unit {
}

@Contract[ensures]
func covNfEmptyEnsures(): Unit {
}

@Contract[requires $pre > 0]
func covNfMisplacedPre(): Unit {
}

@Contract[variable bad]
func covNfBadVariable(): Unit {
}

main() {
}
