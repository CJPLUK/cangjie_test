/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it verifies the §5G
// Phase D wait-for cycle detection: the coordinator tracks lock
// ownership (every acquire the wrappers make is probed under the
// coordinator lock, so even uncontended holds are recorded; releases
// drop the count, a condition wait's one-level release included), and
// every mediated park checks whether its fresh wait-edge closes a cycle
// of mutually-necessary waits. A proven cycle aborts the iteration: the
// Deadlock event records it, every actor parked on its gate is woken
// without a grant, every coordinator entry throws from then on, each
// actor unwinds through the trampoline so the runner's drain completes,
// and the iteration fails with the schedule and the cycle path instead
// of hanging the test binary. Cycle-free stuck waits (an untracked
// external holder, an unnotified condition) keep the recoverable
// Deadlock + Resume behavior — the abort never fires on them.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 6

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctDeadlockTests {
    /// The classic AB-BA cross-lock cycle, forced deterministically with a
    /// monitor handshake: each actor waits (on the condition) until the
    /// other holds its first mutex, then both take their second — the
    /// second park closes the cycle no matter which actor is granted
    /// after the notify.
    @TestCase
    func test_pct_deadlock_cross_lock(): Unit {
        println("Testing PCT deadlock abort (cross-lock cycle)...")

        let m1 = Mutex()
        let m2 = Mutex()
        let mon = Monitor()
        let readyA = AtomicInt64(0)
        let readyB = AtomicInt64(0)
        let result = scenario("pct_deadlock_cross")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(20260925u64)
            .actor {
                m1.lock()
                readyA.store(Int64(1))
                mon.lock()
                while (readyB.load() == Int64(0)) {
                    mon.wait() // park until the peer holds m2
                }
                mon.notify()
                mon.unlock()
                m2.lock() // the peer holds m2
                m2.unlock()
                m1.unlock()
                0
            }
            .actor {
                m2.lock()
                readyB.store(Int64(1))
                mon.lock()
                while (readyA.load() == Int64(0)) {
                    mon.wait() // park until the peer holds m1
                }
                mon.notify()
                mon.unlock()
                m1.lock() // the peer holds m1
                m1.unlock()
                m2.unlock()
                0
            }
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        @Assert(pctIsDeadlocked(schedule))
        @Assert(pctDeadlockCycle(schedule).isSome())
        let cycle = pctDeadlockCycle(schedule).getOrThrow()
        // A closed two-actor cycle over exactly the two initial slots.
        @Assert(cycle.size == 3)
        @Assert(cycle[0] == cycle[2])
        @Assert((cycle[0] == Int64(0) && cycle[1] == Int64(1)) ||
            (cycle[0] == Int64(1) && cycle[1] == Int64(0)))

        var deadlocks = 0
        var blocks = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Deadlock => deadlocks++
                case Block => blocks++
                case _ => ()
            }
        }
        @Assert(deadlocks == 1)
        @Assert(blocks == 0)
    }

    /// No false abort: an unmanaged thread holding the mutex is invisible
    /// to the wait-for graph (its acquire never reached the coordinator),
    /// so the parked actor has no wait-edge and no cycle — the stuck wait
    /// keeps the recoverable behavior (Deadlock, then the external
    /// release's stranded-token grant with a Resume) and the scenario
    /// passes.
    @TestCase
    func test_pct_deadlock_external_holder_recovery(): Unit {
        println("Testing PCT deadlock external-holder recovery...")

        let mx = Mutex()
        let value = AtomicInt64(0)
        let held = AtomicInt64(0)
        let ext = spawn {
            mx.lock()
            held.store(Int64(1))
            sleep(Duration.millisecond * 200)
            mx.unlock()
            0
        }
        while (held.load() == Int64(0)) {
            sleep(Duration.millisecond * 1)
        }

        let result = scenario("pct_deadlock_external")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(31337u64)
            .actor {
                mx.lock()
                value.store(Int64(9))
                mx.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(value.load() == Int64(9))
        @Assert(ext.get() == 0)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        @Assert(!pctIsDeadlocked(schedule))
        @Assert(pctDeadlockCycle(schedule).isNone())
        var deadlocks = 0
        var resumes = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Deadlock => deadlocks++
                case Resume => resumes++
                case _ => ()
            }
        }
        @Assert(deadlocks == 1)
        @Assert(resumes == 1)
    }

    /// A deadlocked schedule is not replayable: the cycle abort unwound
    /// the actors mid-flight (the trailing decisions never happened), so
    /// the replay load rejects it and run() throws. The recorded cycle is
    /// the cross-lock AB-BA shape (a pure mutex cycle).
    @TestCase
    func test_pct_deadlock_replay_rejected(): Unit {
        println("Testing PCT deadlock schedule replay rejection...")

        let m1 = Mutex()
        let m2 = Mutex()
        let mon = Monitor()
        let readyA = AtomicInt64(0)
        let readyB = AtomicInt64(0)
        let recorded = scenario("pct_deadlock_replay_source")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(20260925u64)
            .actor {
                m1.lock()
                readyA.store(Int64(1))
                mon.lock()
                while (readyB.load() == Int64(0)) {
                    mon.wait() // park until the peer holds m2
                }
                mon.notify()
                mon.unlock()
                m2.lock() // the peer holds m2
                m2.unlock()
                m1.unlock()
                0
            }
            .actor {
                m2.lock()
                readyB.store(Int64(1))
                mon.lock()
                while (readyA.load() == Int64(0)) {
                    mon.wait() // park until the peer holds m1
                }
                mon.notify()
                mon.unlock()
                m1.lock() // the peer holds m1
                m1.unlock()
                m2.unlock()
                0
            }
            .build()
            .run()
        @Assert(!recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let dead = recorded.pctSchedule.getOrThrow()
        @Assert(pctIsDeadlocked(dead))

        var rejected = false
        try {
            scenario("pct_deadlock_replay_replay")
                .mode(PCT)
                .priorityChangePoints(0)
                .iterations(1)
                .pctSeed(20260925u64)
                .replaySchedule(dead)
                .actor {
                    0
                }
                .build()
                .run()
        } catch (e: Exception) {
            rejected = true
            println("Replay rejected as expected: ${e.message}")
        }
        @Assert(rejected)
    }

    /// Starvation accounting (the schedule-clock view): each actor's park
    /// count and wait spans (decision events between its park and the
    /// grant that picked it again), derived from the event log. The
    /// consumer's over-acquire parks once and is granted by the producer's
    /// very next decision.
    @TestCase
    func test_pct_wait_stats(): Unit {
        println("Testing PCT wait stats...")

        let sem = Semaphore(1)
        let result = scenario("pct_wait_stats")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                sem.acquire() // silent: takes the initial permit
                sem.acquire() // mediated Wait until the release's flip
                0
            }
            .actor {
                sem.release() // the Release yield point that grants it
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")
        print(schedule.waitStatsReport())

        let stats = pctWaitStats(schedule)
        @Assert(stats.size == 2)
        // The consumer (actor 0, always the top initial rank): one wait,
        // granted by the next decision — a single-event span.
        @Assert(stats[0].waits == 1)
        @Assert(stats[0].blocks == 0)
        @Assert(stats[0].maxWaitSpan == 1)
        @Assert(stats[0].totalWaitSpan == 1)
        @Assert(stats[0].openWaits == 0)
        // The producer never parks.
        @Assert(stats[1].waits == 0)
        @Assert(stats[1].blocks == 0)
        @Assert(stats[1].openWaits == 0)
    }

    /// Two actors parked in timed waits on their own mutexes: nothing
    /// else can run, so this is a would-be deadlock. Under virtual time
    /// each deadline is a deterministic Timer event that fires at
    /// quiescence and grants the parked actor directly — the scenario
    /// completes with no Deadlock/Resume recovery at all (the external
    /// real-time recovery path is covered by the external-holder test).
    @TestCase
    func test_pct_timed_wait_timer_rescue(): Unit {
        println("Testing PCT timed-wait timer rescue...")

        let mA = Mutex()
        let mB = Mutex()

        let result = scenario("pct_transient_deadlock")
            .mode(PCT)
            .iterations(1)
            .actor {
                mA.lock()
                let cond = mA.condition()
                cond.wait(timeout: Duration.millisecond * 200)
                mA.unlock()
                0
            }
            .actor {
                mB.lock()
                let cond = mB.condition()
                cond.wait(timeout: Duration.millisecond * 200)
                mB.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var timers = 0
        var recoveries = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Timer => timers++
                case Deadlock | Resume => recoveries++
                case _ => ()
            }
        }
        // Both waits are rescued by their own virtual deadlines (the
        // equal deadlines fire in slot order), deterministically.
        @Assert(timers == 2)
        @Assert(recoveries == 0)
    }

    /// A timer-schedule (timed waits rescued by virtual deadlines) is
    /// fully deterministic — unlike the external-wake Resume class, it
    /// loads for replay and replays byte-identically.
    @TestCase
    func test_pct_timer_schedule_replays(): Unit {
        println("Testing that a timer schedule replays identically...")

        let mA = Mutex()
        let mB = Mutex()

        let recorded = scenario("pct_deadlock_noreplay_source")
            .mode(PCT)
            .iterations(1)
            .actor {
                mA.lock()
                let cond = mA.condition()
                cond.wait(timeout: Duration.millisecond * 100)
                mA.unlock()
                0
            }
            .actor {
                mB.lock()
                let cond = mB.condition()
                cond.wait(timeout: Duration.millisecond * 100)
                mB.unlock()
                0
            }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let schedule = recorded.pctSchedule.getOrThrow()

        var sawResume = false
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Resume => sawResume = true
                case _ => ()
            }
        }
        @Assert(!sawResume)

        let replayed = scenario("pct_deadlock_noreplay_replay")
            .mode(PCT)
            .replaySchedule(schedule)
            .actor {
                mA.lock()
                let cond = mA.condition()
                cond.wait(timeout: Duration.millisecond * 100)
                mA.unlock()
                0
            }
            .actor {
                mB.lock()
                let cond = mB.condition()
                cond.wait(timeout: Duration.millisecond * 100)
                mB.unlock()
                0
            }
            .build()
            .run()
        @Assert(replayed.passed)
        @Assert(replayed.pctSchedule.isSome())
        let replay = replayed.pctSchedule.getOrThrow()

        var identical = true
        let recordedEvents = pctEvents(schedule)
        let replayEvents = pctEvents(replay)
        if (replayEvents.size != recordedEvents.size) {
            identical = false
        }
        if (identical) {
            for (i in 0..recordedEvents.size) {
                let a = recordedEvents[i]
                let b = replayEvents[i]
                if (a.kind != b.kind || a.from != b.from || a.to != b.to || a.step != b.step) {
                    identical = false
                }
            }
        }
        @Assert(identical)
    }
}
