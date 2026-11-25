/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-078: class-level auxiliary variables whose initializers read
// earlier variables, use string interpolation, and include function-typed
// variables cover the instance-initializer rewriting paths.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable total: Int64 = 0
    variable step: Int64 = total + 1
    variable label: String = "t${step}"
    invariant total >= 0
]
class CovVarChain {
    public init() {}
    public func grow(n: Int64): Unit {
        @ghost ( total += n )
    }
    public func read(): Int64 {
        total
    }
}

@Test
class Test {
    @TestCase
    func testInitializerChains() {
        let c = CovVarChain()
        c.grow(4)
        @Expect(c.read(), 4)
    }
}
