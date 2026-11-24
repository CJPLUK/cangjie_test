/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-088: a `return` inside `synchronized (m) { ... }` leaves the constructor
// through the lock release, which is still an ordinary exit and must run the exit
// checks. Fixed (defect 2; see contract-defects-audit.md): `SynchronizedExpr` was
// not traversed, so the early exit skipped both the invariant and `ensures` checks.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import std.sync.*
import stdx.contract.macros.*

@Contract [ invariant x == 1 ]
class CovSyncInvariant {
    public var x: Int64 = 2

    public init(mode: Int64) {
        let m = Mutex()
        if (mode == 0) {
            synchronized (m) {
                return
            }
        }
        x = 1
    }
}

class CovSyncEnsures {
    public var x: Int64 = 2

    @Contract [ ensures x == 1 ]
    public init(mode: Int64) {
        let m = Mutex()
        if (mode == 0) {
            synchronized (m) {
                return
            }
        }
        x = 1
    }
}

@Test
class Test {
    // COV-088 (negative): the early exit leaves `x` at 2, violating the type
    // invariant; the check must run before the synchronized block is left.
    @TestCase
    func syncExitInvariantEnforced() {
        var caught = false
        try {
            let _ = CovSyncInvariant(0)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // COV-088 (negative): same shape with a constructor `ensures` clause only.
    @TestCase
    func syncExitEnsuresEnforced() {
        var caught = false
        try {
            let _ = CovSyncEnsures(0)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // COV-088 (positive): the fall-through exit still runs the checks and passes.
    @TestCase
    func syncFallThroughAccepted() {
        @Expect(CovSyncInvariant(1).x, 1)
        @Expect(CovSyncEnsures(1).x, 1)
    }
}
