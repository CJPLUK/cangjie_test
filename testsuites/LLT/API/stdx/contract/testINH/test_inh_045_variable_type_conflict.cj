/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-045 (negative, EXEC-PIPE-1): two parent interfaces declare the
// same-named class-level variable with different types; the design requires a
// clean compile error. Fixed (defect 16.17): the diagnostic reporter falls
// back to the annotated declaration's tokens when an inherited clause's
// foreign tokens cannot be passed to `diagReport`, so the conflict is
// reported instead of crashing macro expansion with
// `ASTException: Illegal input tokens`.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan has conflicting declarations; same-name variables must share type
// ASSERT: scan-not Illegal input tokens
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract[
    variable x: Int64 = 1
]
interface InhConflictA {
    func fa(): Unit
}

@Contract[
    variable x: Bool = true
]
interface InhConflictB {
    func fb(): Unit
}

@Contract[
    inherits from InhConflictA
    inherits from InhConflictB
]
class InhConflictImpl <: InhConflictA & InhConflictB {
    public init() {}
    public func fa(): Unit {}
    public func fb(): Unit {}
}

main() {
    println("unreachable")
}
