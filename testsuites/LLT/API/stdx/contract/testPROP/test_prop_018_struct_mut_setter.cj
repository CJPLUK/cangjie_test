/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-PROP-018: a setter clause directly annotated on a struct's
// `mut prop` compiles and enforces the setter contract. Fixed (defect 16.35;
// see contract-defects-audit.md): the setter accessor was generated without the
// `mut` modifier, which failed to compile against the mutable struct receiver.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

struct PropMutSetter {
    var x: Int64
    init(x!: Int64) {
        this.x = x
    }

    @Contract [set ensures this.x >= 0]
    mut prop p: Int64 {
        get() {
            x
        }
        set(v) {
            x = v
        }
    }
}

@Test
class Test {
    // CT-PROP-018 (positive): the generated setter accessor carries the `mut`
    // modifier, so a non-negative assignment compiles and is stored.
    @TestCase
    func prop018SetterAccepted() {
        var q = PropMutSetter(x: 1)
        q.p = 5
        @Expect(q.p, 5)
    }

    // CT-PROP-018 (negative): the setter `ensures this.x >= 0` rejects a
    // negative assignment with ContractCheckEnsuresException.
    @TestCase
    func prop018SetterEnsuresEnforced() {
        var q = PropMutSetter(x: 1)
        var caught = false
        try {
            q.p = -1
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
