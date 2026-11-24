/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// PROP-034: a `return` nested in a `let` initializer inside a directly annotated
// setter is an ordinary setter exit; the inlined body must run the setter
// postcondition on that path too. Fixed (defect 3; see contract-defects-audit.md):
// the exit-check scan skipped `VarDecl`, so the early exit bypassed `ensures`.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class PropVarInitExit {
    private var _x: Int64 = 0

    @Contract [ set ensures _x == 1 ]
    public mut prop x: Int64 {
        get() {
            _x
        }
        set(v) {
            _x = 2
            let y = if (v == 0) {
                return
            } else {
                1
            }
            _x = y
        }
    }
}

@Test
class Test {
    // PROP-034 (negative): the early exit leaves `_x` at 2, so the postcondition
    // must fire from inside the initializer.
    @TestCase
    func propVarInitExitEnsuresEnforced() {
        var caught = false
        try {
            let p = PropVarInitExit()
            p.x = 0
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // PROP-034 (positive): the fall-through exit satisfies the postcondition.
    @TestCase
    func propVarInitFallThroughAccepted() {
        let p = PropVarInitExit()
        p.x = 5
        @Expect(p.x, 1)
    }
}
