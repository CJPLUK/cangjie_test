/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-059: when CANGJIE_STDX_CONTRACT_META_DIR names a plain
// file instead of a directory, the persistence probe fails and persistence
// is skipped silently; the library still builds and consumers compile.
// DEPENDENCE: cov_persist_lib_nopkg.cj
// EXEC: rm -rf %n_meta && touch %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covshapes %compiler %import-cangjie-stdx %cmp_opt cov_persist_lib_nopkg.cj --output-type=staticlib -o lib%n_nopkg2.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=nopkgcons %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt --import-path . -L . -l %n_nopkg2
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import nopkg.*

class PlainUser {
    public init() {}

    public func call(d: Int64): Int64 {
        let b = NopkgBase()
        b.add(d)
        d
    }
}

@Test
class Test {
    @TestCase
    func testMetaFileSkippedPersist() {
        let u = PlainUser()
        @Expect(u.call(2), 2)
    }
}
