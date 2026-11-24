/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-080: a `[conforming]` extend implements an abstract
// interface property and combines the inherited contract with its own local
// `ensures` contract. Exercises inheritance-aware extend property processing.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract
interface VCovConfPropBase {
    @Contract [
        get ensures r: r > 0
    ]
    prop p: Int64
}

class VCovConfPropHost {
    public init() {}
}

@Contract [
    inherits from VCovConfPropBase [conforming]
]
extend VCovConfPropHost <: VCovConfPropBase {
    @Contract [
        get ensures r: r > 0 && r < 100
    ]
    public prop p: Int64 {
        get() {
            2
        }
    }
}

@Test
class Test {
    @TestCase
    func testConformingExtendProperty() {
        let host = VCovConfPropHost()
        @Expect(host.p, 2)
    }
}
