/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-002: `&&=`/`||=` compound assignments inside `@ghost` blocks
// exercise the logical compound-assignment operator mapping in the auxiliary
// update rewriter.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable counter: Int64 = 0
    variable flag: Bool = true
    ensures r: r == n
]
func covAuxPrefix(n: Int64): Int64 {
    @ghost ( flag &&= n > 0 )
    @ghost ( counter += 1 )
    @ghost ( flag ||= n < 100 )
    n
}

@Contract [
    variable track: Int64 = 10
    variable gate: Bool = false
    ensures r: r == n
]
func covAuxPrefixMix(n: Int64): Int64 {
    @ghost ( gate ||= n > 0 )
    @ghost ( track *= 2 )
    @ghost ( gate &&= n < 5 )
    n
}

@Test
class Test {
    @TestCase
    func testCompoundOps() {
        @Expect(covAuxPrefix(3), 3)
        @Expect(covAuxPrefixMix(2), 2)
    }
}
