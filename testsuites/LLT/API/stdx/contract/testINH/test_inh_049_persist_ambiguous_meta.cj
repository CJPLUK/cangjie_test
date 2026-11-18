/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-049 (supplement): ambiguous on-disk records. Two parent packages
// built with different CANGJIE_STDX_CONTRACT_PKG_NAME values leave
// `inhmetaa.PersistBase.cmeta` and `inhmetab.PersistBase.cmeta` in one meta
// directory. A consumer that references the simple name cannot pick between
// the two records, so reportAmbiguousMeta warns and skips the inheritance
// instead of silently inheriting the wrong contract. Compile-positive control:
// the consumer compiles with the WARNING and runs with no inherited contract.
// DEPENDENCE: inh_persist_lib_a.cj
// DEPENDENCE: inh_persist_lib_b.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa %compiler %import-cangjie-stdx %cmp_opt inh_persist_lib_a.cj --output-type=staticlib -o lib%n_a.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetab %compiler %import-cangjie-stdx %cmp_opt inh_persist_lib_b.cj --output-type=staticlib -o lib%n_b.a
// EXEC-PIPE-0: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta %compiler %import-cangjie-stdx %cmp_opt %f -o %n.%suffix --import-path . -L . -l %n_a 2>&1 | compare %f
// ASSERT: scan-not core dumped
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

/* SCAN-IN
ambiguous contract metadata for `PersistBase`: 2 records match
*/

import stdx.contract.macros.*
import inhmetaa.*

// No explicit `inherits from` clause: the ambiguous lookup happens while the
// macro resolves the ancestor metadata for the class-level `variable audit`,
// warns, and skips the inheritance, so compilation succeeds.
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
    // Contracts are not inherited by default and the ambiguous metadata was
    // skipped, so the violating call is not blocked either: both calls reach
    // the override body (2 * 2 + (-1) * 2 == 2).
    c.add(-1)
    if (c.total != 2) {
        throw Exception("unexpected total ${c.total}")
    }
}
