/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-063: cross-package inheritance loads a persisted record
// whose parent carries property contracts, a parenthesized `throws` type, an
// `inherits invariant` clause, and a class-level `variable`.
// DEPENDENCE: cov_persist_lib_shapes.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covshapes %compiler %import-cangjie-stdx %cmp_opt cov_persist_lib_shapes.cj --output-type=staticlib -o lib%n_covshapes.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covconsumer %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt --import-path . -L . -l %n_covshapes
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import covshapes.*

@Contract [
    inherits from covshapes.ShapeBase
]
class ShapeChild <: ShapeBase {
    public init() {
        super()
    }

    public override func risky(x: Int64): Int64 {
        if (x < 0) {
            throw ShapeErr()
        }
        x + 1
    }
}

@Test
class Test {
    @TestCase
    func testPersistedShapes() {
        let c = ShapeChild()
        @Expect(c.risky(3), 4)
        @Expect(c.gauge, 1)
        var threw = false
        try {
            c.risky(-1)
        } catch (e: ShapeErr) {
            threw = true
        }
        @Expect(threw, true)
        c.bump(1)
    }
}
