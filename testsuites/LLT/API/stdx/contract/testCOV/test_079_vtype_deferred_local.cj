/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-079: a member function of a type-level contract that also
// carries its own deferred contract and declares a local function with a
// contract. Lowering the absorbed local function forces the declaration to be
// re-emitted (owner.toTokens()) while the type-level contract keeps the
// deferred member contract.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract []
class VCovDeferredHost {
    public init() {}

    @Contract [
        requires x > 0
        ensures r: r > 0
    ]
    public func outer(x: Int64): Int64 {
        @Contract [ requires y > 0 ]
        func inner(y: Int64): Int64 {
            y + 1
        }
        inner(x)
    }
}

@Test
class Test {
    @TestCase
    func testDeferredLocal() {
        let host = VCovDeferredHost()
        @Expect(host.outer(2), 3)
        var caught = false
        try {
            host.outer(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
