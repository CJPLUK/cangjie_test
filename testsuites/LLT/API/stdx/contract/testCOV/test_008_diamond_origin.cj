/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-008: the same ancestor reached through two interface parents shares
// its contract provenance, so the diamond merge is silent and the inherited checks
// still run on the leaf override.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract []
interface CovDiaBase {
    @Contract [
        requires [lower] x > 0
        requires [upper] x < 100
    ]
    func f(x: Int64): Int64 {
        x
    }
}

@Contract [
    inherits from CovDiaBase
]
interface CovDiaLeft <: CovDiaBase {
}

@Contract [
    inherits from CovDiaBase
]
interface CovDiaRight <: CovDiaBase {
}

@Contract [
    inherits from CovDiaLeft
    inherits from CovDiaRight
]
class CovDiaLeaf <: CovDiaLeft & CovDiaRight {
    public init() {}

    public func f(x: Int64): Int64 {
        x
    }
}

@Test
class TestDiamondOrigin {
    @TestCase
    func testDiamondInheritedChecks() {
        @Expect(CovDiaLeaf().f(1), 1)
        @Expect(CovDiaLeaf().f(50), 50)
    }
}
