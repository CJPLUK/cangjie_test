/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-053 (audit H5): an interface publishes its member parameter names in
// the contract metadata, so an implementor may rename the parameters positionally
// and still inherit the contract.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract
interface InhParamIface {
    @Contract [
        requires x > 0
    ]
    func take(x: Int64): Int64
}

@Contract [
    inherits from InhParamIface
]
class InhParamImpl <: InhParamIface {
    public init() {}

    // Renamed from `x` to `y`: the inherited clause must bind by position.
    public func take(y: Int64): Int64 {
        y
    }
}

@Test
class Test {
    @TestCase
    func testInh053InterfaceParamRename() {
        var caught = false
        try {
            InhParamImpl().take(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(InhParamImpl().take(5), 5)
    }
}
