/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-050 (supplement): a corrupted on-disk record. Overwriting the parent's
// `.cmeta` file (equivalently: a record left by an incompatible contract
// library version, which fails the CFGMETA/META_FORMAT_VERSION header check)
// must not fail the consumer's compilation: parseMetaData reports a one-time
// WARNING and the inheritance is skipped. Compile-positive control: the
// consumer compiles with the WARNING and runs with no inherited contract.
// DEPENDENCE: inh_persist_lib_a.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa %compiler %import-cangjie-stdx %cmp_opt inh_persist_lib_a.cj --output-type=staticlib -o lib%n_a.a
// EXEC: echo corrupted-by-test > %n_meta/inhmetaa.PersistBase.cmeta
// EXEC-PIPE-0: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta %compiler %import-cangjie-stdx %cmp_opt %f -o %n.%suffix --import-path . -L . -l %n_a 2>&1 | compare %f
// ASSERT: scan-not core dumped
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

/* SCAN-IN
contract metadata record for `PersistBase` is unreadable
*/

import stdx.contract.macros.*
import inhmetaa.*

// No explicit `inherits from` clause: the unreadable record is reported as a
// WARNING while the macro resolves the ancestor metadata for the class-level
// `variable audit`, and the inheritance is skipped, so compilation succeeds.
@Contract
class PersistChild <: PersistBase {
    public init() {
        super()
    }

    public override func add(d: Int64): Unit {
        total += d * 2
    }
}

main() {
    let c = PersistChild()
    c.add(2)
    // Contracts are not inherited by default and the unreadable record made
    // the inheritance unavailable, so the violating call is not blocked:
    // both calls reach the override body (2 * 2 + (-1) * 2 == 2).
    c.add(-1)
    if (c.total != 2) {
        throw Exception("unexpected total ${c.total}")
    }
}
