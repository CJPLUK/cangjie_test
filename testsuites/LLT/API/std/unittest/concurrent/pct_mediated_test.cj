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
// Phase B mediated sync traffic: a contended mutex lock or semaphore
// acquire by a PCT actor parks on the coordinator gate (a Wait event,
// keyed by the primitive) instead of the runtime, and an unlock/release
// with waiters is a yield point (an Unlock/Release event) that flips the
// waiters and picks the next holder; a non-actor release revives a
// stranded waiter (Deadlock + Resume). Uncontended operations stay
// invisible, and non-actor threads keep the plain runtime park.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctMediatedTests {
    /// Two actors ping-ponging one mutex: every contended acquisition is a
    /// mediated Wait (never a runtime Block), every unlock with waiters is
    /// an Unlock yield point, mutual exclusion holds, and no deadlock or
    /// recovery appears — the actor-only wake-race-free end state of §5G.
    @TestCase
    func test_pct_mediated_mutex_handoff(): Unit {
        println("Testing PCT mediated mutex handoff...")

        let m = Mutex()
        let inSection = AtomicInt64(0)
        let violations = AtomicInt64(0)
        let rounds = 10

        let result = scenario("pct_mediated_handoff")
            .mode(PCT)
            .priorityChangePoints(4)
            .iterations(3)
            .pctSeed(20260925u64)
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    let cur = inSection.fetchAdd(1)
                    if (cur != 0) {
                        violations.fetchAdd(1)
                    }
                    inSection.fetchAdd(-1)
                    m.unlock()
                }
                0
            }
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    let cur = inSection.fetchAdd(1)
                    if (cur != 0) {
                        violations.fetchAdd(1)
                    }
                    inSection.fetchAdd(-1)
                    m.unlock()
                }
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(violations.load() == 0)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var waits = 0
        var unlocks = 0
        var blocks = 0
        var deadlocks = 0
        var resumes = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case Unlock => unlocks++
                case Block => blocks++
                case Deadlock => deadlocks++
                case Resume => resumes++
                case _ => ()
            }
        }
        // Actor-only traffic on a shared mutex with grid interleaving:
        // contention is mediated (Wait + Unlock), never a runtime park.
        @Assert(waits >= 1)
        @Assert(unlocks >= 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
        @Assert(resumes == 0)
    }

    /// The mediated handoff replays bit-for-bit: every Wait/Unlock decision
    /// is a deterministic function of the schedule (the flip happens under
    /// the coordinator lock in the same decision that grants the token).
    @TestCase
    func test_pct_mediated_mutex_replay(): Unit {
        println("Testing PCT mediated mutex replay...")

        let m = Mutex()
        let inSection = AtomicInt64(0)
        let rounds = 10

        let recorded = scenario("pct_mediated_replay_source")
            .mode(PCT)
            .priorityChangePoints(4)
            .iterations(1)
            .pctSeed(20260925u64)
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    inSection.fetchAdd(1)
                    m.unlock()
                }
                0
            }
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    inSection.fetchAdd(1)
                    m.unlock()
                }
                0
            }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let s1 = recorded.pctSchedule.getOrThrow()
        println("Recorded: ${s1.report()}")

        let replayed = scenario("pct_mediated_replay_replay")
            .mode(PCT)
            .priorityChangePoints(pctSchedulePcpBudget(s1))
            .iterations(1)
            .pctSeed(pctScheduleSeed(s1))
            .replaySchedule(s1)
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    inSection.fetchAdd(1)
                    m.unlock()
                }
                0
            }
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    inSection.fetchAdd(1)
                    m.unlock()
                }
                0
            }
            .build()
            .run()

        @Assert(replayed.passed)
        @Assert(replayed.pctSchedule.isSome())
        let s2 = replayed.pctSchedule.getOrThrow()
        println("Replayed: ${s2.report()}")

        @Assert(!pctIsDiverged(s2))
        let aEvents = pctEvents(s1)
        let bEvents = pctEvents(s2)
        @Assert(bEvents.size == aEvents.size)
        for (i in 0..aEvents.size) {
            let a = aEvents[i]
            let b = bEvents[i]
            if (a.kind != b.kind || a.from != b.from || a.to != b.to || a.step != b.step) {
                @Assert(false)
            }
        }
    }

    /// A semaphore rendezvous between a consumer (first actor — always the
    /// top initial rank, so with no priority-change points it runs its op
    /// uninterrupted) and a producer: the consumer drains the semaphore
    /// and its over-acquire is a mediated Wait (the producer is still
    /// gated); the producer's release flips it — a Release yield point —
    /// and the granted waiter's tryAcquire retry succeeds. The std.sync
    /// semaphore contract bounds the count by its initial value (a
    /// Semaphore(0) can never be released), so the rendezvous starts
    /// full, not empty.
    @TestCase
    func test_pct_mediated_semaphore(): Unit {
        println("Testing PCT mediated semaphore rendezvous...")

        let permits = 5
        let sem = Semaphore(permits)
        let consumed = AtomicInt64(0)

        let result = scenario("pct_mediated_semaphore")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                for (_ in 0..(permits + 1)) {
                    sem.acquire()
                    consumed.fetchAdd(1)
                }
                0
            }
            .actor {
                for (_ in 0..(permits + 1)) {
                    sem.release()
                }
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        // The consumer drains the initial five permits plus the one the
        // producer's yield-point release flips it for.
        @Assert(consumed.load() == Int64(permits + 1))
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var waits = 0
        var releases = 0
        var blocks = 0
        var deadlocks = 0
        var resumes = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case Release => releases++
                case Block => blocks++
                case Deadlock => deadlocks++
                case Resume => resumes++
                case _ => ()
            }
        }
        // The consumer drains the full semaphore, so its (permits+1)-th
        // acquire is deterministically contended while the producer is
        // still gated: exactly one mediated Wait, and the producer's
        // release that flips it is a Release yield point. No runtime
        // parks, no deadlock, no recovery.
        @Assert(waits == 1)
        @Assert(releases == 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
        @Assert(resumes == 0)
    }

    /// A non-actor thread holding the mutex: the actor's contended lock is
    /// still mediated (Wait), the park finds nobody gated (single actor),
    /// so a Deadlock is recorded; the non-actor's unlock flips the waiter
    /// and grants the stranded token — a Resume recovery, exactly like a
    /// timed-wait expiry, and the schedule is marked non-replayable by it.
    @TestCase
    func test_pct_mediated_external_release(): Unit {
        println("Testing PCT mediated external release...")

        let m = Mutex()
        let held = AtomicInt64(0)

        // Unmanaged thread (spawned outside the scenario window: its spawn
        // site absorbs, so it never registers): it takes the mutex, marks
        // it held, sleeps, then releases — its release flips the waiting
        // actor and revives the stranded token.
        let ext = spawn {
            m.lock()
            held.store(1)
            sleep(Duration.millisecond * 200)
            m.unlock()
            0
        }

        let result = scenario("pct_mediated_external")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(1)
            .pctSeed(31337u64)
            .actor {
                // Spin (grid points only; a lone actor cannot trip the
                // fair-mode switch) until the external thread holds the
                // mutex, so the lock below is deterministically contended.
                while (held.load() == 0) {
                }
                m.lock()
                m.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(ext.get() == 0)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var waits = 0
        var unlocks = 0
        var blocks = 0
        var deadlocks = 0
        var resumes = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case Unlock => unlocks++
                case Block => blocks++
                case Deadlock => deadlocks++
                case Resume => resumes++
                case _ => ()
            }
        }
        // The mediated park finds nobody gated (a lone actor), so it logs
        // Deadlock — Wait, like Block, is only logged on an actual
        // transfer — and the actor parks on its coordinator gate (state
        // Waiting, keyed by the mutex). The non-actor's release flips the
        // waiter and grants the stranded token (Resume). The unlock itself
        // is non-actor, so it logs no Unlock event.
        @Assert(waits == 0)
        @Assert(unlocks == 0)
        @Assert(blocks == 0)
        @Assert(deadlocks == 1)
        @Assert(resumes == 1)
    }
}
