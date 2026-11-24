/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-061: record lookup across several meta directories.
//  * `CovPrefDup` has a byte-identical record in two directories, so the
//    duplicate is dropped instead of being reported as ambiguous.
//  * `CovPrefOther` has two *different* records (inhmetaa / inhmetab); the
//    consumer package is inhmetaa, so the same-package record wins.
//  * A third directory is unreadable while the consumer compiles; it behaves
//    like a miss instead of breaking the build.
// DEPENDENCE: cov_persist_lib_a.cj
// DEPENDENCE: cov_persist_lib_b.cj
// EXEC: rm -rf %n_meta1 %n_meta2 %n_meta3 && mkdir -p %n_meta1 %n_meta2 %n_meta3
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta1 CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa %compiler %import-cangjie-stdx %cmp_opt cov_persist_lib_a.cj --output-type=staticlib -o lib%n_a.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta2 CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetab %compiler %import-cangjie-stdx %cmp_opt cov_persist_lib_b.cj --output-type=staticlib -o lib%n_b.a
// EXEC: cp %n_meta1/inhmetaa.CovPrefDup.cmeta %n_meta2/
// EXEC: chmod 000 %n_meta3
// EXEC-PIPE-0: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta1:%n_meta2:%n_meta3 CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa %compiler %import-cangjie-stdx %cmp_opt %f -o %n.%suffix --import-path . -L . -l %n_a -l %n_b %cmp_utest_opt 2>&1 | compare %f
// EXEC: chmod 755 %n_meta3
// ASSERT: scan-not core dumped
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*
import inhmetaa.*

@Contract
class CovPrefDupChild <: CovPrefDup {
    public init() {
        super()
    }

    public override func add(d: Int64): Unit {
        total += d * 2
    }
}

@Contract
class CovPrefOtherChild <: CovPrefOther {
    public init() {
        super()
    }

    public override func add(d: Int64): Unit {
        total += d * 3
    }
}

@Test
class Test {
    @TestCase
    func duplicateRecordStillRuns() {
        let c = CovPrefDupChild()
        c.add(2)
        @Expect(c.total, 4)
    }

    @TestCase
    func samePackageRecordStillRuns() {
        let c = CovPrefOtherChild()
        c.add(2)
        @Expect(c.total, 6)
    }
}
