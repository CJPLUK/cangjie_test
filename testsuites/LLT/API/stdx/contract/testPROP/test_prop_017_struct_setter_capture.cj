/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-PROP-017: a `mut prop` contract on a struct compiles and
// enforces both accessors. Fixed (defect 16.16; see contract-defects-audit.md):
// the setter body is hoisted into a private `mut` member instead of a local
// function, which cannot capture the mutable receiver in a struct `mut` context.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract
struct PropStructSetter {
    private var stored: Int64 = 0

    public init() {}

    @Contract[
        get ensures r: r == stored
        set requires value >= 0
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }
}

@Test
class Test {
    // CT-PROP-017 (positive): the hoisted setter body runs with the mutable
    // receiver, so the assignment is stored and the getter observes it.
    @TestCase
    func prop017SetterAccepted() {
        var s = PropStructSetter()
        s.value = 1
        @Expect(s.value, 1)
    }

    // CT-PROP-017 (negative): the setter `requires value >= 0` rejects a
    // negative assignment with ContractCheckRequiresException.
    @TestCase
    func prop017SetterRequiresEnforced() {
        var s = PropStructSetter()
        var blocked = false
        try {
            s.value = -1
        } catch (e: ContractCheckRequiresException) {
            blocked = true
        }
        @Expect(blocked, true)
    }
}
