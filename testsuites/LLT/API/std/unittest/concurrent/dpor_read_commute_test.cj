/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: this file MUST be compiled with --cj-pct — it verifies the DPOR
// dependency oracle's read-commutativity: same-location READS commute
// (two loads, or two failed compare-and-swaps, of one atomic never
// create a backtrack point), while any write-class touch (a store, an
// RMW, a successful CAS) keeps both orders explored. The wrappers'
// pctGridDispatchRw classifies every atomic op (a failed CAS reports
// write=false), so these scenarios exercise the classified grid notes
// end to end (dpor plan §5.1).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

import stdx.unittest.concurrent.*
import std.sync.*

@Test
class DporReadCommuteTests {
    /// Two pure reads of one atomic are INDEPENDENT: no backtrack point
    /// is created, the exploration exhausts after the single schedule.
    @TestCase
    func test_dpor_read_read_single_schedule(): Unit {
        println("Testing DPOR read-read commutativity...")

        let result = scenario("dpor_read_read")
            .mode(DPOR)
            .iterations(1000)
            .withState { => AtomicInt64(7) }
            .actor { s: AtomicInt64 => s.load() }
            .actor { s: AtomicInt64 => s.load() }
            .verify { s => s.load() == 7 }
            .build()
            .run()

        @Assert(result.passed)
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            println("Read-read: schedules=${d.schedulesExplored} exhausted=${d.exhausted}")
            @Assert(d.schedulesExplored == 1)
            @Assert(d.exhausted)
            @Assert(!d.deadlocked)
        }
    }

    /// A read and a write of one atomic are DEPENDENT: both orders of
    /// the two segments are explored before exhaustion.
    @TestCase
    func test_dpor_read_write_explores(): Unit {
        println("Testing DPOR read-write dependence...")

        let result = scenario("dpor_read_write")
            .mode(DPOR)
            .iterations(1000)
            .withState { => AtomicInt64(0) }
            .actor { s: AtomicInt64 => s.load() }
            .actor { s: AtomicInt64 => s.fetchAdd(1) }
            .verify { s => s.load() == 1 }
            .build()
            .run()

        @Assert(result.passed)
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            println("Read-write: schedules=${d.schedulesExplored} exhausted=${d.exhausted}")
            @Assert(d.schedulesExplored >= 2)
            @Assert(d.exhausted)
            @Assert(!d.deadlocked)
        }
    }

    /// A FAILED compare-and-swap writes nothing and commutes with other
    /// reads of the key: two CASes that can never succeed (the expected
    /// value never matches) leave the space at a single schedule. This
    /// is the regression guard for the failed-CAS-is-a-read rule —
    /// misclassifying failures as writes doubles the exploration.
    @TestCase
    func test_dpor_failed_cas_is_read(): Unit {
        println("Testing DPOR failed-CAS-as-read...")

        let result = scenario("dpor_failed_cas_read")
            .mode(DPOR)
            .iterations(1000)
            .withState { => AtomicInt64(0) }
            .actor { s: AtomicInt64 => s.compareAndSwap(5, 6) }
            .actor { s: AtomicInt64 => s.compareAndSwap(5, 6) }
            .verify { s => s.load() == 0 }
            .build()
            .run()

        @Assert(result.passed)
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            println("Failed-CAS: schedules=${d.schedulesExplored} exhausted=${d.exhausted}")
            @Assert(d.schedulesExplored == 1)
            @Assert(d.exhausted)
            @Assert(!d.deadlocked)
        }
    }

    /// A SUCCESSFUL compare-and-swap is a write: whichever actor wins,
    /// the loser's CAS fails (a read against the winner's write) — the
    /// pairs are dependent in both directions and both orders are
    /// explored.
    @TestCase
    func test_dpor_successful_cas_orders(): Unit {
        println("Testing DPOR successful-CAS dependence...")

        let result = scenario("dpor_successful_cas")
            .mode(DPOR)
            .iterations(1000)
            .withState { => AtomicInt64(0) }
            .actor { s: AtomicInt64 => s.compareAndSwap(0, 1) }
            .actor { s: AtomicInt64 => s.compareAndSwap(0, 2) }
            .verify { s => let v = s.load(); v == 1 || v == 2 }
            .build()
            .run()

        @Assert(result.passed)
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            println("Successful-CAS: schedules=${d.schedulesExplored} exhausted=${d.exhausted}")
            @Assert(d.schedulesExplored >= 2)
            @Assert(d.exhausted)
            @Assert(!d.deadlocked)
        }
    }
}
