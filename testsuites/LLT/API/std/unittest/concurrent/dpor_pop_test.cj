/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: this file MUST be compiled with --cj-pct — it verifies the POP
// engine (stdx.unittest.concurrent dpor_pop.cj, tasks/
// dpor_pop_migration_plan.md) through the scenario DSL (.mode(DPOR)):
// the parsimonious reversal of happens-before-adjacent races explores
// exactly one window per Mazurkiewicz class of the sync-key partial
// order. The fixture counts are the paper's canonical shapes (CAV 2024):
// two writers of one key explore 2 schedules, three writers 6 (= 3!),
// write-write-read-read 4 (the read/write crossings of two INDEPENDENT
// keys — read-read commutes), read-write-write 6, writer+two-readers 5
// without the sleep-set characterization and 4 with it (the compatible
// read schedules from one write — the Stage-2 characterization's
// canonical shape). Every exhaustion case also asserts diverged=0: a
// faithfully-synthesized guide replays its pinned prefix
// bit-identically (a divergence means the schedule-entry synthesis or
// the prefix-determinism contract broke).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 11

import stdx.unittest.concurrent.*
import std.sync.*

@Test
class DporPopTests {
    /// Two single writers of one atomic: exactly the two orders of the
    /// dependent segments — 2 Mazurkiewicz classes, 2 schedules, exhausted.
    @TestCase
    func test_dpor_pop_two_writes(): Unit {
        println("Testing POP two-writer optimality...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_pop_two_writes")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("w1") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                x.store(2)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Two writes: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(r.schedulesExplored == 2)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
        @Assert(!r.depthPruned)
        @Assert(r.stats.contains("diverged=0"))
    }

    /// Three single writers of one atomic: all 3! = 6 orders, each
    /// explored exactly once (the parsimony conditions drop the races
    /// whose reversal revisits an explored class — the factorial does
    /// NOT become 3!·k windows).
    @TestCase
    func test_dpor_pop_three_writes(): Unit {
        println("Testing POP three-writer optimality...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_pop_three_writes")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("w1") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                x.store(2)
                0
            }])
            .actorWithOps([operation<Int64>("w3") { =>
                x.store(3)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Three writes: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(r.schedulesExplored == 6)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
        @Assert(r.stats.contains("diverged=0"))
    }

    /// The paper's write-write + read-read shape: A stores x, B stores
    /// y (independent keys), C reads x then y. The classes are the four
    /// read/write crossings (each read before or after its write);
    /// the two reads commute with each other, and the two writes are
    /// independent — 4 classes, 4 schedules.
    @TestCase
    func test_dpor_pop_write_write_read_read(): Unit {
        println("Testing POP write-write/read-read optimality...")

        let x = AtomicInt64(0)
        let y = AtomicInt64(0)
        let r = scenario("dpor_pop_wwrr")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("wx") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("wy") { =>
                y.store(1)
                0
            }])
            .actorWithOps([
                operation<Int64>("rx") { =>
                    let _ = x.load()
                    0
                },
                operation<Int64>("ry") { =>
                    let _ = y.load()
                    0
                }
            ])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("WWRR: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(r.schedulesExplored == 4)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
        @Assert(r.stats.contains("diverged=0"))
    }

    /// The paper's read-write-write shape: one reader and two writers
    /// of one key — all 6 orders of the three mutually dependent
    /// segments are distinct classes (the read commutes with nothing
    /// here): 6 schedules.
    @TestCase
    func test_dpor_pop_read_write_write(): Unit {
        println("Testing POP read-write-write optimality...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_pop_rww")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("r") { =>
                let _ = x.load()
                0
            }])
            .actorWithOps([operation<Int64>("w1") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                x.store(2)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("RWW: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(r.schedulesExplored == 6)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
        @Assert(r.stats.contains("diverged=0"))
    }

    /// Two pure readers of one atomic: same-location reads commute, no
    /// race exists, the single schedule exhausts (the oracle's
    /// read-commutativity carries over to POP unchanged).
    @TestCase
    func test_dpor_pop_load_only_single(): Unit {
        println("Testing POP read-read commutativity...")

        let x = AtomicInt64(7)
        let r = scenario("dpor_pop_load_only")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("r1") { =>
                let _ = x.load()
                0
            }])
            .actorWithOps([operation<Int64>("r2") { =>
                let _ = x.load()
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Load-only: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(r.schedulesExplored == 1)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
    }

    /// Actors on disjoint keys are independent: one schedule.
    @TestCase
    func test_dpor_pop_disjoint_keys_single(): Unit {
        println("Testing POP disjoint-key independence...")

        let p = AtomicInt64(0)
        let q = AtomicInt64(0)
        let r = scenario("dpor_pop_disjoint")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("pa") { =>
                let _ = p.fetchAdd(1)
                0
            }])
            .actorWithOps([operation<Int64>("qb") { =>
                let _ = q.fetchAdd(1)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Disjoint: schedules=${r.schedulesExplored} exhausted=${r.exhausted} (${r.stats})")
        @Assert(r.schedulesExplored == 1)
        @Assert(r.exhausted)
        @Assert(!r.deadlocked)
    }

    /// The schedule budget stops the exploration early: one window,
    /// not exhausted.
    @TestCase
    func test_dpor_pop_budget_stops(): Unit {
        println("Testing POP schedule budget...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_pop_budget")
            .mode(DPOR)
            .iterations(1)
            .actorWithOps([operation<Int64>("w1") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                x.store(2)
                0
            }])
            .actorWithOps([operation<Int64>("w3") { =>
                x.store(3)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Budget: schedules=${r.schedulesExplored} exhausted=${r.exhausted}")
        @Assert(r.schedulesExplored == 1)
        @Assert(!r.exhausted)
    }

    /// The switch bound prunes children whose pinned guide plans more
    /// Grants than the bound (the depth analogue of the budget): bound
    /// 0 leaves the first reversal unexplored — 1 window, depthPruned,
    /// not exhausted; a generous bound completes the 2-class space.
    @TestCase
    func test_dpor_pop_switch_bound(): Unit {
        println("Testing POP switch bound...")

        let xA = AtomicInt64(0)
        let zero = scenario("dpor_pop_sb_zero")
            .mode(DPOR)
            .iterations(1000)
            .switchBound(0)
            .actorWithOps([operation<Int64>("w1") { =>
                xA.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                xA.store(2)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()
        println("Bound 0: schedules=${zero.schedulesExplored} exhausted=${zero.exhausted} " +
            "depthPruned=${zero.depthPruned} (${zero.stats})")
        @Assert(zero.schedulesExplored == 1)
        @Assert(!zero.exhausted)
        @Assert(zero.depthPruned)

        let xB = AtomicInt64(0)
        let wide = scenario("dpor_pop_sb_wide")
            .mode(DPOR)
            .iterations(1000)
            .switchBound(64)
            .actorWithOps([operation<Int64>("w1") { =>
                xB.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                xB.store(2)
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()
        println("Bound 64: schedules=${wide.schedulesExplored} exhausted=${wide.exhausted} " +
            "depthPruned=${wide.depthPruned} (${wide.stats})")
        @Assert(wide.schedulesExplored == 2)
        @Assert(wide.exhausted)
        @Assert(!wide.depthPruned)
    }

    /// POP is a deterministic function of the scenario: two runs
    /// explore the same windows with the same statistics.
    @TestCase
    func test_dpor_pop_deterministic(): Unit {
        println("Testing POP determinism...")

        let x1 = AtomicInt64(0)
        let first = scenario("dpor_pop_det_1")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("w1") { =>
                x1.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                x1.store(2)
                0
            }])
            .actorWithOps([operation<Int64>("r") { =>
                let _ = x1.load()
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        let x2 = AtomicInt64(0)
        let second = scenario("dpor_pop_det_2")
            .mode(DPOR)
            .iterations(1000)
            .actorWithOps([operation<Int64>("w1") { =>
                x2.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                x2.store(2)
                0
            }])
            .actorWithOps([operation<Int64>("r") { =>
                let _ = x2.load()
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Determinism: ${first.schedulesExplored}/${second.schedulesExplored} " +
            "stats-equal=${first.stats == second.stats}")
        @Assert(first.schedulesExplored == second.schedulesExplored)
        @Assert(first.exhausted == second.exhausted)
        @Assert(first.stats == second.stats)
        @Assert(first.exhausted)
    }

    /// A crossing-lock shape (the classic two-mutex deadlock) is still
    /// found: the exploration reaches the schedule whose wait-for graph
    /// closes the cycle, the window aborts (the Phase D proven-deadlock
    /// path) and the abort is reported; the failing schedule stops the
    /// exploration (first-failure semantics) and fails the scenario
    /// run. The mutexes are rebuilt FRESH per schedule by the state
    /// factory (the stateless contract — an aborted schedule unwinds
    /// mid-acquire, so its unlocks never run and reused mutexes would
    /// stay locked forever). NoValidation keeps the auto validator's
    /// sequential re-execution away from the crossing locks (a
    /// sequential interleaving of the single-lock operations could park
    /// forever).
    @TestCase
    func test_dpor_pop_deadlock_reported(): Unit {
        println("Testing POP deadlock reporting...")

        let result = scenario("dpor_pop_deadlock")
            .mode(DPOR)
            .iterations(100)
            .consistencyModel(NoValidation)
            .withState { => DporPopDlState() }
            .actorWithOps([
                operation<Int64, DporPopDlState>("a_m1") { s => s.m1.lock(); 0 },
                operation<Int64, DporPopDlState>("a_m2") { s => s.m2.lock(); 0 },
                operation<Int64, DporPopDlState>("a_r2") { s => s.m2.unlock(); 0 },
                operation<Int64, DporPopDlState>("a_r1") { s => s.m1.unlock(); 0 }
            ])
            .actorWithOps([
                operation<Int64, DporPopDlState>("b_m2") { s => s.m2.lock(); 0 },
                operation<Int64, DporPopDlState>("b_m1") { s => s.m1.lock(); 0 },
                operation<Int64, DporPopDlState>("b_r1") { s => s.m1.unlock(); 0 },
                operation<Int64, DporPopDlState>("b_r2") { s => s.m2.unlock(); 0 }
            ])
            .build()
            .run()

        let r = result.dporReport.getOrThrow()
        println("Deadlock: schedules=${r.schedulesExplored} exhausted=${r.exhausted} " +
            "deadlocked=${r.deadlocked} (${r.stats})")
        @Assert(!result.passed)
        @Assert(r.deadlocked)
        // The crossing is not found trivially: the root schedule (fully
        // serial) and its two direct reversal children complete without
        // a cycle, so the aborting schedule is the third or later.
        @Assert(r.schedulesExplored >= 3)
        @Assert(!r.exhausted)
    }

    /// The sleep-set characterization (Stage 2 — dpor_pop_sschar.cj,
    /// the paper's Section 4.3): one writer plus two independent readers
    /// of one atomic has 4 Mazurkiewicz classes (each subset of readers
    /// before the write), but the compatible read schedules from the one
    /// write make Stage-1 semantics explore 5 windows — the [C,B,A]
    /// window revisits the class of the [B,C,A] window (both readers
    /// before the write). The characterization's line-7 check skips the
    /// duplicate reversal (sleepSkipped=1): the σ_C child's window
    /// reverses (A,B) — its σ = [B-load] against the characterization
    /// [B-poll,B-load]⊳x created for σ_C removes B-load from the P (the
    /// contained-schedule identity) and B-load, a read of x with no
    /// prior R-read, completes the sleeping read-x-schedule — so the
    /// child is never pushed, and the exploration visits each class
    /// exactly once: 4 windows. Both modes stay exhausted and diverged=0.
    @TestCase
    func test_dpor_pop_sschar_read_schedules(): Unit {
        println("Testing POP sleep-set characterization...")

        let x = AtomicInt64(0)
        let off = scenario("dpor_pop_sschar_off")
            .mode(DPOR)
            .iterations(100)
            .sleepCharMode(DporSleepCharMode.Off)
            .actorWithOps([operation<Int64>("w") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("r1") { =>
                let _ = x.load()
                0
            }])
            .actorWithOps([operation<Int64>("r2") { =>
                let _ = x.load()
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()
        let chr = scenario("dpor_pop_sschar_char")
            .mode(DPOR)
            .iterations(100)
            .sleepCharMode(DporSleepCharMode.Char)
            .actorWithOps([operation<Int64>("w") { =>
                x.store(1)
                0
            }])
            .actorWithOps([operation<Int64>("r1") { =>
                let _ = x.load()
                0
            }])
            .actorWithOps([operation<Int64>("r2") { =>
                let _ = x.load()
                0
            }])
            .build()
            .run()
            .dporReport
            .getOrThrow()

        println("Sleep char Off : schedules=${off.schedulesExplored} exhausted=${off.exhausted} (${off.stats})")
        println("Sleep char Char: schedules=${chr.schedulesExplored} exhausted=${chr.exhausted} (${chr.stats})")
        @Assert(off.schedulesExplored == 5) // 4 classes + the duplicate window
        @Assert(chr.schedulesExplored == 4) // exactly one window per class
        @Assert(off.exhausted)
        @Assert(chr.exhausted)
        @Assert(!chr.deadlocked)
        @Assert(!chr.depthPruned)
        @Assert(chr.stats.contains("sleepSkipped=1"))
        @Assert(chr.stats.contains("diverged=0"))
    }
}

/// Fresh per-schedule mutexes: an aborted schedule unwinds mid-acquire
/// and never runs its unlocks, so the state must not survive the
/// schedule.
class DporPopDlState {
    public let m1: Mutex = Mutex()
    public let m2: Mutex = Mutex()
}
