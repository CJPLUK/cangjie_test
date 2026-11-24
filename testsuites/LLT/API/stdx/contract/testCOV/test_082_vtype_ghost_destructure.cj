/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-082: a constructor `@ghost` block that binds a tuple
// pattern shadows local names through the destructuring-group scanner while the
// auxiliary variable is still assigned.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable aux: Int64
    invariant aux >= 0
]
class VCovGhostDestructure {
    VCovGhostDestructure(public let n: Int64) {
        @ghost(
            let (first, second) = (n, n + 1)
            aux = first + second
        )
    }
}

@Test
class Test {
    @TestCase
    func testDestructuringGhost() {
        let c = VCovGhostDestructure(3)
        @Expect(c.n, 3)
    }
}
