/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-032 (audit H1): a bare `return` in a constructor that carries a
// declaration-level contract without `ensures`/`throws` used to bypass the
// instance invariant check, so the object was constructed in a violating state.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    on_public invariant [positive] value > 0
]
class ClsBareReturnCtor {
    var value: Int64 = 1

    // Only `requires`: the expanded constructor has no exit-check node for the
    // invariant to attach to, so the bare `return` needs its own check.
    @Contract [requires true]
    init(flag: Bool) {
        if (flag) {
            value = 0
            return
        }
    }
}

@Test
class Test {
    @TestCase
    func testCls032BareReturnInvariant() {
        var caught = false
        try {
            let _ = ClsBareReturnCtor(true)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(ClsBareReturnCtor(false).value, 1)
    }
}
