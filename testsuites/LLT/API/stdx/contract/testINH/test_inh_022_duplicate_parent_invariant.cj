/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-022 (implementation deviation): DT expects a compile error when two
// unrelated parents both declare the invariant `[I1]` and the child inherits
// both, with a hint to rename one. Under design v2 §3.4.1 an implicit parent
// invariant is not inherited unless the child writes `inherits from` /
// `inherits invariant`, so no duplicate is formed here and the program
// compiles; the duplicate diagnostic only fires for explicitly inherited
// labels (see test_inh_017_renamed_duplicate.cj, which renames both parents'
// `I1` to `I2`). Landed as a compile-positive control pinning the current
// behaviour instead of asserting an error that no longer exists.
// EXEC-PIPE-0: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    invariant [I1] true
]
interface InhNeg022A {
    public func run(): Unit
}

@Contract[
    invariant [I1] true
]
interface InhNeg022B {
    public func walk(): Unit
}

@Contract
class InhNeg022Sub <: InhNeg022A & InhNeg022B {
    public init() {}

    public func run(): Unit {}

    public func walk(): Unit {}
}

main() {
}
