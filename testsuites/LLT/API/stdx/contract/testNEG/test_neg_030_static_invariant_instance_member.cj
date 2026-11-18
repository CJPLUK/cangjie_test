/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-030: L574 — a `static invariant` may only use static members. Reading
// ordinary instance members (a function call or a field) from a static
// invariant is reported by the contract macro itself, naming the member,
// instead of relying on the compiler's generic resolution error.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan instance member `helper` cannot be accessed from a `static invariant`
// ASSERT: scan instance member `amount` cannot be accessed from a `static invariant`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    static invariant [S030] helper() && amount > 0
]
class Neg030StaticContext {
    public var amount: Int64 = 1

    public init() {}

    public func helper(): Bool {
        true
    }

    public static func probe(): Int64 {
        1
    }
}

main() {
}
