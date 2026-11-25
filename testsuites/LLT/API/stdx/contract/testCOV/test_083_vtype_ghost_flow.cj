/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-083: type-level validation scanning of a primary
// constructor `@ghost` block that is preceded by braced control flow, contains
// nested braces and a top-level `return`, a member body that mentions the
// internal gate identifier outside a real gate block, and an `?`-typed
// abstract variable (indirect type reference).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable aux: Int64
    invariant aux >= 0
]
class VCovGhostFlow {
    VCovGhostFlow(public let n: Int64) {
        if (n < 0) {
            ()
        }
        @ghost(
            aux = n
            if (n > 0) {
                aux = n + 1
            }
            return
        )
    }

    public func shadow(m: Int64): Int64 {
        let _contract_gateEnabled = m
        _contract_gateEnabled
    }
}

@Contract [
    variable maybe: ?Int64 = None
    invariant true
]
class VCovOptionVar {
    public init() {}
}

@Test
class Test {
    @TestCase
    func testGhostFlow() {
        let c = VCovGhostFlow(2)
        @Expect(c.n, 2)
        @Expect(c.shadow(7), 7)
        let o = VCovOptionVar()
        @Expect(o is VCovOptionVar, true)
    }
}
