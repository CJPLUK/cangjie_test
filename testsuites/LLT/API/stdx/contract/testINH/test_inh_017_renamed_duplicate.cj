/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-017: two parent contracts rename their invariants to the same name.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited invariant `I2` is declared by multiple ancestors; rename one with `inherits invariant <new> = <type>.I2`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    invariant [I1] true
]
interface InhNeg017A {
    public func run(): Unit
}

@Contract[
    invariant [I1] true
]
interface InhNeg017B {
    public func walk(): Unit
}

@Contract[
    inherits invariant I2 = InhNeg017A.I1
    inherits invariant I2 = InhNeg017B.I1
]
class InhNeg017Sub <: InhNeg017A & InhNeg017B {
    public init() {}

    public func run(): Unit {}

    public func walk(): Unit {}
}

main() {
}
