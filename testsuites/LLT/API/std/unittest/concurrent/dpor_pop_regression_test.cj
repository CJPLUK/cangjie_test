/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: this file MUST be compiled with --cj-pct — it pins the
// canonical explored-schedule counts of the POP engine
// (stdx.unittest.concurrent dpor_pop.cj / dpor_pop_sschar.cj), driven
// through the scenario DSL (.mode(DPOR)), on the paper's canonical
// shapes: two writers of one key explore 2 schedules, three writers 6,
// write-write/read-read 4 (two INDEPENDENT keys — the read/write
// crossings), read-write-write 6, and writer+two-readers 5 in Stage-1
// semantics and 4 with the sleep-set characterization (whose line-7
// check skips exactly one duplicate reversal). These counts are the
// count-preservation anchor for the engine's soundness guards: the
// happens-before order guard in the sleep-set characterization's
// reference resolution, the dependence conjunct in the race scan (a
// spawn edge alone does not race), and the sibling exclusion-chain
// anchor — each of which only removes WRONG decisions (an over-blocked
// class, a wasted spawn-only reversal, a candidate never
// tried-and-blocked at the decision it was skipped at), so a fixture
// that never hits the wrong path must explore exactly the same
// windows: exhausted, diverged=0, and no fresh-position block
// (sleepBlocked=0) on the sleep-set shape.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 5

import stdx.unittest.concurrent.*
import std.sync.*

@Test
class DporPopRegressionTests {
    /// Two single writers of one atomic: exactly the two orders of the
    /// dependent segments — 2 Mazurkiewicz classes, 2 schedules, exhausted
    /// with a faithful guide replay on every schedule.
    @TestCase
    func test_dpor_fix_two_writes(): Unit {
        println("Testing POP two-writer count preservation...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_fix_two_writes")
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
        @Assert(r.stats.contains("sleepBlocked=0"))
    }

    /// Three single writers of one atomic: all 3! = 6 orders, each
    /// explored exactly once — the parsimony conditions keep the
    /// factorial from multiplying.
    @TestCase
    func test_dpor_fix_three_writes(): Unit {
        println("Testing POP three-writer count preservation...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_fix_three_writes")
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
        @Assert(r.stats.contains("sleepBlocked=0"))
    }

    /// The write-write + read-read shape: two INDEPENDENT keys, the
    /// reader loads x then y — the four read/write crossings are the
    /// classes; the reads commute with each other: 4 schedules.
    @TestCase
    func test_dpor_fix_write_write_read_read(): Unit {
        println("Testing POP write-write/read-read count preservation...")

        let x = AtomicInt64(0)
        let y = AtomicInt64(0)
        let r = scenario("dpor_fix_wwrr")
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

    /// The read-write-write shape: one reader and two writers of one
    /// key — all 6 orders of the three mutually dependent segments are
    /// distinct classes: 6 schedules.
    @TestCase
    func test_dpor_fix_read_write_write(): Unit {
        println("Testing POP read-write-write count preservation...")

        let x = AtomicInt64(0)
        let r = scenario("dpor_fix_rww")
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
        @Assert(r.stats.contains("sleepBlocked=0"))
    }

    /// The sleep-set characterization's canonical shape: one writer
    /// plus two independent readers of one atomic has 4 Mazurkiewicz
    /// classes; the compatible read schedules from the one write make
    /// Stage-1 semantics explore a fifth (duplicate) window, while the
    /// characterization's line-7 check skips exactly that reversal
    /// (sleepSkipped=1) and no executed window's fresh continuation
    /// completes a sleeping schedule (sleepBlocked=0 — no sibling
    /// push exists on this shape). Both modes stay exhausted with
    /// faithful prefix replays.
    @TestCase
    func test_dpor_fix_sschar_read_schedules(): Unit {
        println("Testing POP sleep-set characterization count preservation...")

        let x = AtomicInt64(0)
        let off = scenario("dpor_fix_sschar_off")
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
        let chr = scenario("dpor_fix_sschar_char")
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
        @Assert(chr.stats.contains("sleepBlocked=0"))
        @Assert(chr.stats.contains("diverged=0"))
        @Assert(off.stats.contains("sleepSkipped=0"))
    }
}
