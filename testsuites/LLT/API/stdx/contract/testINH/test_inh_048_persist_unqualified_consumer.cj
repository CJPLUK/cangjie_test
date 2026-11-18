/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-048 (supplement): simple-name records interop. The parent record is
// written package-qualified (`inhmetaa.PersistBase.cmeta`, parent built with
// CANGJIE_STDX_CONTRACT_PKG_NAME), while the consumer is compiled WITHOUT
// CANGJIE_STDX_CONTRACT_PKG_NAME. A simple-name lookup must still find the
// record through the `<pkg>.<Name>.cmeta` suffix match in metaFileCandidates,
// so the explicit `inherits from PersistBase` clause resolves and the loaded
// `requires` is merged onto the child's override.
// DEPENDENCE: inh_persist_lib_a.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa %compiler %import-cangjie-stdx %cmp_opt inh_persist_lib_a.cj --output-type=staticlib -o lib%n_inhmetaa.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt --import-path . -L . -l %n_inhmetaa
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import inhmetaa.*

@Contract[
    inherits from PersistBase
]
class PersistChild <: PersistBase {
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

    @TestCase
    func overrideBodyRuns() {
        let c = PersistChild()
        c.add(2)
        @Expect(c.total, 6)
    }
}
