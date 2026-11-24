/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-060: the parent package is compiled without
// CANGJIE_STDX_CONTRACT_PKG_NAME; its disk record stores an empty package
// name, and the consumer (which does carry a package identity) must resolve
// the package-qualified reference against that record.
// DEPENDENCE: cov_persist_lib_nopkg.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta %compiler %import-cangjie-stdx %cmp_opt cov_persist_lib_nopkg.cj --output-type=staticlib -o lib%n_nopkg.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=nopkgcons %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt --import-path . -L . -l %n_nopkg
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import nopkg.*

@Contract [
    inherits from NopkgBase
]
class NopkgChild <: NopkgBase {
    public init() {
        super()
    }
}

@Test
class Test {
    @TestCase
    func testNopkgParent() {
        let c = NopkgChild()
        c.add(2)
        var blocked = false
        try {
            c.add(-1)
        } catch (e: ContractCheckRequiresException) {
            blocked = true
        }
        @Expect(blocked, true)
    }
}
