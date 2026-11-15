/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: this file MUST be compiled with --cj-pct — it pins that a
// tryLock outcome participates in the DPOR dependency oracle: the
// stdx.unittest.sync wrappers dispatch the classified grid check on
// the primitive's key after every public tryLock (success =
// write-class — the primitive's state changed; failure = read-class —
// a pure state observation), so try-ing actors are dependent with each
// other and with lock-holding traffic. The two-racers shape is the
// sharp pin: each actor's single tryLock op touches no other key (the
// winner never needs the lock again, so it never unlocks), so without
// the dispatch the two actors would be independent — exactly one
// explored schedule — while with it the two outcome assignments (which
// racer's tryLock sees the free lock) are distinct dependency classes
// and both orders must be explored. The hold/release shape covers the
// tryLock against full acquire/release traffic as a lower bound (the
// try's conditional unlock notes the key on success, so its count is
// not an exact class pin). Both shapes must exhaust within the budget.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 2

import stdx.unittest.concurrent.*
import std.sync.*

/// Fresh per-schedule state of the two-racers shape: one shared mutex.
class DporTryLockRaceState {
    public let m: Mutex = Mutex()
}

/// Fresh per-schedule state of the hold/release shape: one shared mutex.
class DporTryLockHoldState {
    public let m: Mutex = Mutex()
}

@Test
class DporTryLockDepTests {
    /// Two racers, one tryLock each, on a shared mutex: the token
    /// protocol serializes them, so exactly one tryLock sees the free
    /// lock (a write-class dispatch) and the other sees it held (a
    /// read-class dispatch) — a dependent pair on the mutex's key, so
    /// DPOR must explore both orders. Neither actor touches any other
    /// key, so without the classified dispatch the actors would be
    /// independent and a single schedule would cover the shape.
    @TestCase
    func test_dpor_trylock_racers_dependency(): Unit {
        println("Testing DPOR tryLock dependency (two racers)...")

        let result = scenario("dpor_trylock_racers")
            .mode(DPOR)
            .iterations(1000)
            .withState { => DporTryLockRaceState() }
            .consistencyModel(NoValidation)
            .actorWithOps([operation<Int64, DporTryLockRaceState>("tryA") { s =>
                if (s.m.tryLock()) {
                    1
                } else {
                    0
                }
            }])
            .actorWithOps([operation<Int64, DporTryLockRaceState>("tryB") { s =>
                if (s.m.tryLock()) {
                    1
                } else {
                    0
                }
            }])
            .build()
            .run()
        let r = result.dporReport.getOrThrow()

        println("Racers: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(result.passed)
        // Exactly 2 Mazurkiewicz classes: the tryLock write/read pair is
        // dependent, so both acquire orders are explored (without the
        // classified dispatch the actors are independent: exactly 1).
        @Assert(r.schedulesExplored == 2)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
    }

    /// A lock holder split across two operations (the op boundary
    /// between them is the interleaving window) against a tryLocker
    /// that releases again on success: the tryLock's classified
    /// dispatch makes the try dependent with the holder's
    /// acquire/release segments — the try before the hold, between
    /// hold and release (where it fails), and after the release (where
    /// it succeeds) are distinct dependency orders, so the exploration
    /// must cover more than the independent single schedule.
    @TestCase
    func test_dpor_trylock_hold_window_dependency(): Unit {
        println("Testing DPOR tryLock dependency (hold window)...")

        let result = scenario("dpor_trylock_hold_window")
            .mode(DPOR)
            .iterations(1000)
            .withState { => DporTryLockHoldState() }
            .consistencyModel(NoValidation)
            .actorWithOps([
                operation<Int64, DporTryLockHoldState>("hold") { s =>
                    s.m.lock()
                    0
                },
                operation<Int64, DporTryLockHoldState>("release") { s =>
                    s.m.unlock()
                    0
                }
            ])
            .actorWithOps([operation<Int64, DporTryLockHoldState>("try") { s =>
                let ok = s.m.tryLock()
                if (ok) {
                    s.m.unlock()
                }
                0
            }])
            .build()
            .run()
        let r = result.dporReport.getOrThrow()

        println("Hold window: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(result.passed)
        // Exactly 5 Mazurkiewicz classes (both tryLock outcomes crossing
        // the holder's two-operation window, incl. the contended follow-up
        // acquire); the count is the dependency-oracle anchor for the
        // tryLock dispatch — pin it exactly.
        @Assert(r.schedulesExplored == 5)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
    }
}
