/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-021: named class-level invariants inherited by member
// reference and by rename; a multi-line invariant label exercises the
// newline-skipping token scan, and the renamed copy gets a fresh identity so
// duplicate de-duplication keeps it.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable counter: Int64 = 0
    invariant [lower]
        counter >= 0
    invariant [upper] counter < 100
]
open class InvRenBase {
    public init() {}
}

@Contract [
    inherits invariant renamedLower = InvRenBase.lower
    inherits invariant InvRenBase.upper
]
class InvRenChild <: InvRenBase {
    public init() {}
}

@Test
class Test {
    @TestCase
    func testInvRen() {
        let c = InvRenChild()
        @Expect(c.counter >= 0, true)
    }
}
