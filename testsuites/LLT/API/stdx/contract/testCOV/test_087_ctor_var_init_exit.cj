/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-087: a `return` nested in a `let` initializer (the `if` expression supplies
// the declared type) is an ordinary constructor exit. Both exit scans must descend
// into the initializer: the type invariant injection and the `ensures` exit check.
// Fixed (defect 1; see contract-defects-audit.md): the scans only walked expression
// nodes and skipped `VarDecl`, so the early exit skipped both checks.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [ invariant x == 1 ]
class CovVarInitInvariant {
    public var x: Int64 = 2

    public init(mode: Int64) {
        let y = if (mode == 0) {
            return
        } else {
            1
        }
        x = y
    }
}

class CovVarInitEnsures {
    public var x: Int64 = 2

    @Contract [ ensures x == 1 ]
    public init(mode: Int64) {
        let y = if (mode == 0) {
            return
        } else {
            1
        }
        x = y
    }
}

@Test
class Test {
    // COV-087 (negative): the early exit leaves `x` at 2, violating the type
    // invariant; only a check injected inside the initializer can report it.
    @TestCase
    func varInitExitInvariantEnforced() {
        var caught = false
        try {
            let _ = CovVarInitInvariant(0)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // COV-087 (negative): same shape with a constructor `ensures` clause only,
    // which exercises the exit-check scan independently of the invariant scan.
    @TestCase
    func varInitExitEnsuresEnforced() {
        var caught = false
        try {
            let _ = CovVarInitEnsures(0)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // COV-087 (positive): the fall-through exit still runs the checks and passes.
    @TestCase
    func varInitFallThroughAccepted() {
        @Expect(CovVarInitInvariant(1).x, 1)
        @Expect(CovVarInitEnsures(1).x, 1)
    }
}
