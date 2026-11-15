/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 2

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctBrokerTests {
    /// Block transfer across actors: while one actor parks in a timed wait
    /// (a deterministic BLOCK — the wait parks unconditionally), the other
    /// actor contends on the same mutex; whenever the priority order
    /// interleaves the waiter's lock and wait, the second actor blocks
    /// UNTIMED and is woken by the waiter's unlock — the re-gate path woken
    /// by another actor rather than a timer. Progress (no hang, every
    /// iteration completes) is asserted deterministically.
    @TestCase
    func test_pct_block_transfer_progress(): Unit {
        println("Testing PCT block transfer progress...")

        let m = Mutex()

        let result = scenario("pct_block_transfer")
            .mode(PCT)
            .iterations(4)
            .actor {
                m.lock()
                let cond = m.condition()
                cond.wait(timeout: Duration.millisecond * 50)
                m.unlock()
            }
            .actor {
                m.lock()
                m.unlock()
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var blocks = 0
        var deadlocks = 0
        var timers = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Block => blocks++
                case Deadlock => deadlocks++
                case Timer => timers++
                case _ => ()
            }
        }
        // The timed wait parks unconditionally and completes
        // deterministically: under virtual time its deadline is a Timer
        // event firing at quiescence that grants the parked actor
        // directly; Block (a gated actor existed — the token moved) and
        // Deadlock (timerless park, recovered externally) remain possible
        // in mixed schedules.
        @Assert(blocks + deadlocks + timers >= 1)
    }

    /// Actor-operation exceptions are captured as operation results (the
    /// consistency validator reasons about thrown operations), but the
    /// protocol must still complete cleanly: the actor's finally releases
    /// the token, the lead is shut down, the broker disarms, and a
    /// subsequent PCT scenario in the same process arms and records
    /// normally (no broker leak).
    @TestCase
    func test_pct_actor_exception_does_not_leak_broker(): Unit {
        println("Testing PCT actor exception hygiene...")

        let threw = scenario("pct_actor_exception")
            .mode(PCT)
            .iterations(1)
            .actor {
                throw IllegalArgumentException("boom")
            }
            .actor { => 0 }
            .build()
            .run()

        @Assert(threw.pctSchedule.isSome())
        println("Exception-op schedule: ${threw.pctSchedule.getOrThrow().report()}")

        // A fresh PCT iteration must arm cleanly: a leaked broker would
        // fail activation with -3.
        let result = scenario("pct_after_exception")
            .mode(PCT)
            .iterations(2)
            .actor { => 1 }
            .actor { => 2 }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        println("Follow-up schedule: ${result.pctSchedule.getOrThrow().report()}")
    }
}
