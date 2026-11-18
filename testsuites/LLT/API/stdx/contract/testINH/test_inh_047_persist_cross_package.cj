/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-047 (supplement): cross-package contract inheritance through the
// on-disk `.cmeta` records (persist.cj). The parent package is compiled in its
// own cjc process with CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa, so its metadata
// is not in the consumer's in-memory registry; the explicit
// `inherits from inhmetaa.PersistBase` clause can only resolve by loading
// `inhmetaa.PersistBase.cmeta` from CANGJIE_STDX_CONTRACT_META_DIR (without the
// record the compile fails with "parent contract metadata is unavailable").
// The consumer carries its own package identity (inhconsumer), so the parent
// reference must be package-qualified: a bare name would be rejected as a
// foreign-package record. The loaded `requires` is merged onto the child's
// override, so the runtime assertions pin the full load-and-merge behavior.
// DEPENDENCE: inh_persist_lib_a.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa %compiler %import-cangjie-stdx %cmp_opt inh_persist_lib_a.cj --output-type=staticlib -o lib%n_inhmetaa.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhconsumer %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt --import-path . -L . -l %n_inhmetaa
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import inhmetaa.*

@Contract[
    inherits from inhmetaa.PersistBase
]
class PersistChild <: PersistBase {
    public init() {
        super()
    }

    public override func add(d: Int64): Unit {
        total += d * 2
    }
}

@Test
class Test {
    // The inherited `requires d >= 0` fires before the override body runs,
    // which is only possible when the parent metadata was loaded from disk.
    @TestCase
    func inheritedRequiresEnforced() {
        let c = PersistChild()
        var blocked = false
        try {
            c.add(-1)
        } catch (e: ContractCheckRequiresException) {
            blocked = true
        }
        @Expect(blocked, true)
    }

    // The override body itself runs normally for a valid input.
    @TestCase
    func overrideBodyRuns() {
        let c = PersistChild()
        c.add(2)
        @Expect(c.total, 4)
    }
}
