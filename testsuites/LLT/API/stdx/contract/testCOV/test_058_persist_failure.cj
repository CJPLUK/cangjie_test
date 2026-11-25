/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-058: persistence failure handling. A compile with an empty
// CANGJIE_STDX_CONTRACT_META_DIR value exercises the "no candidate directory"
// early return; a compile with a fresh directory exercises `Directory.create`;
// a meta directory whose parent is a regular file makes `Directory.create`
// fail; and a regular file used as the meta directory makes the temporary
// record file unopenable, so the exception is rethrown and the one-time
// WARNING is emitted while compilation still succeeds.
// EXEC: printf 'x' > %n_meta_file
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta_file/sub %compiler %import-cangjie-stdx %cmp_opt -o %n.nodir.%suffix %f %cmp_utest_opt
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=: %compiler %import-cangjie-stdx %cmp_opt -o %n.empty.%suffix %f %cmp_utest_opt
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_fresh_meta %compiler %import-cangjie-stdx %cmp_opt -o %n.fresh.%suffix %f %cmp_utest_opt
// EXEC-PIPE-0: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta_file %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt 2>&1 | compare %f
// ASSERT: scan contract inheritance metadata could not be persisted
// ASSERT: scan-not core dumped
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

@Contract [
    invariant [nonNegative] total >= 0
]
open class CovPersistFailBase {
    public var total: Int64 = 0

    public init() {}

    @Contract [
        requires d >= 0
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}

@Test
class Test {
    @TestCase
    func basicCheck() {
        let b = CovPersistFailBase()
        b.add(2)
        @Expect(b.total, 2)
    }

    @TestCase
    func requiresStillEnforced() {
        let b = CovPersistFailBase()
        var blocked = false
        try {
            b.add(-1)
        } catch (e: ContractCheckRequiresException) {
            blocked = true
        }
        @Expect(blocked, true)
    }
}
