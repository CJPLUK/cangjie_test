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
// Phase C mediated condition traffic: an actor's untimed Monitor.wait /
// Condition.wait releases the owner lock and parks on the coordinator
// gate keyed by the condition (a Wait event subsuming the release), a
// notify/notifyAll flips condition waiters (one / all) and is a yield
// point (Notify/NotifyAll events), and the granted waiter re-acquires
// the owner lock through the mediated acquire protocol — the two-stage
// Mesa re-wait when contended (a second, lock-keyed Wait). ReadWriteLock
// views share one key, so any unlock flips every lock waiter and their
// retry probes sort read/write eligibility. A non-actor notify/unlock
// revives a stranded waiter (Deadlock + Resume).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 7

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctConditionTests {
    /// The canonical Mesa handoff on a Monitor: the consumer's wait is one
    /// merged decision (release + condition park, a Wait), the producer's
    /// notify is a Notify yield point, the consumer's re-acquire finds the
    /// producer still holding (a second, lock-keyed Wait — the two-stage
    /// Mesa re-wait), and the producer's unlock admits it (an Unlock).
    @TestCase
    func test_pct_condition_handoff(): Unit {
        println("Testing PCT mediated condition handoff...")

        let m = Monitor()
        let flag = AtomicInt64(0)
        let value = AtomicInt64(0)

        let result = scenario("pct_condition_handoff")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                m.lock()
                while (flag.load() == Int64(0)) {
                    m.wait()
                }
                value.store(Int64(42))
                m.unlock()
                0
            }
            .actor {
                m.lock()
                flag.store(Int64(1))
                m.notify()
                m.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(value.load() == Int64(42))
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var waits = 0
        var notifies = 0
        var unlocks = 0
        var blocks = 0
        var deadlocks = 0
        var resumes = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case Notify => notifies++
                case Unlock => unlocks++
                case Block => blocks++
                case Deadlock => deadlocks++
                case Resume => resumes++
                case _ => ()
            }
        }
        // Condition park + contended Mesa re-acquire; no runtime parks,
        // no deadlock, no recovery.
        @Assert(waits == 2)
        @Assert(notifies == 1)
        @Assert(unlocks == 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
        @Assert(resumes == 0)
    }

    /// The mediated condition handoff replays bit-for-bit (same binary):
    /// every Wait/Notify/Unlock decision is a deterministic function of
    /// the schedule.
    @TestCase
    func test_pct_condition_replay(): Unit {
        println("Testing PCT mediated condition replay...")

        let m = Monitor()
        let flag = AtomicInt64(0)

        let recorded = scenario("pct_condition_replay_source")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                m.lock()
                while (flag.load() == Int64(0)) {
                    m.wait()
                }
                m.unlock()
                0
            }
            .actor {
                m.lock()
                flag.store(Int64(1))
                m.notify()
                m.unlock()
                0
            }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let s1 = recorded.pctSchedule.getOrThrow()
        println("Recorded: ${s1.report()}")

        flag.store(Int64(0))
        let replayed = scenario("pct_condition_replay_replay")
            .mode(PCT)
            .priorityChangePoints(pctSchedulePcpBudget(s1))
            .iterations(1)
            .pctSeed(pctScheduleSeed(s1))
            .replaySchedule(s1)
            .actor {
                m.lock()
                while (flag.load() == Int64(0)) {
                    m.wait()
                }
                m.unlock()
                0
            }
            .actor {
                m.lock()
                flag.store(Int64(1))
                m.notify()
                m.unlock()
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

    /// notifyAll with two waiters: one NotifyAll event covers the batch
    /// flip (both waiters become eligible in the same yield decision),
    /// and both re-acquire serially — each contended re-acquire is its
    /// own lock-keyed Wait.
    @TestCase
    func test_pct_condition_notify_all(): Unit {
        println("Testing PCT mediated notifyAll...")

        let m = Monitor()
        let flag = AtomicInt64(0)
        let got = AtomicInt64(0)

        let result = scenario("pct_condition_notify_all")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                m.lock()
                while (flag.load() == Int64(0)) {
                    m.wait()
                }
                got.fetchAdd(1)
                m.unlock()
                0
            }
            .actor {
                m.lock()
                while (flag.load() == Int64(0)) {
                    m.wait()
                }
                got.fetchAdd(1)
                m.unlock()
                0
            }
            .actor {
                m.lock()
                flag.store(Int64(1))
                m.notifyAll()
                m.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(got.load() == Int64(2))
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var waits = 0
        var notifyAlls = 0
        var unlocks = 0
        var blocks = 0
        var deadlocks = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case NotifyAll => notifyAlls++
                case Unlock => unlocks++
                case Block => blocks++
                case Deadlock => deadlocks++
                case _ => ()
            }
        }
        // Two condition parks + two contended re-acquires; one batch
        // flip; the producer's unlock admits the re-acquire waiters.
        @Assert(waits == 4)
        @Assert(notifyAlls == 1)
        @Assert(unlocks == 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
    }

    /// The modern condition API: a shared `Mutex.condition()` (created
    /// under the lock — each `condition()` call is an independent wait
    /// queue, so the actors must share one instance), `waitUntil` looping
    /// the mediated wait, and `notifyAll` from the producer.
    @TestCase
    func test_pct_condition_mutex_api(): Unit {
        println("Testing PCT mediated Mutex.condition...")

        let mx = Mutex()
        let ready = AtomicInt64(0)
        let value = AtomicInt64(0)
        mx.lock()
        let cond = mx.condition()
        mx.unlock()

        let result = scenario("pct_condition_mutex_api")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                mx.lock()
                cond.waitUntil({ => ready.load() == Int64(1) })
                value.store(Int64(7))
                mx.unlock()
                0
            }
            .actor {
                mx.lock()
                ready.store(Int64(1))
                cond.notifyAll()
                mx.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(value.load() == Int64(7))
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var waits = 0
        var notifyAlls = 0
        var unlocks = 0
        var blocks = 0
        var deadlocks = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case NotifyAll => notifyAlls++
                case Unlock => unlocks++
                case Block => blocks++
                case Deadlock => deadlocks++
                case _ => ()
            }
        }
        @Assert(waits == 2)
        @Assert(notifyAlls == 1)
        @Assert(unlocks == 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
    }

    /// A non-actor notifier: the lone actor's condition park records a
    /// Deadlock (nobody gated), the external thread's notify flips it and
    /// grants the stranded token (a Resume — non-actor notifies log no
    /// Notify event), and the Mesa re-acquire either succeeds silently
    /// (the external unlock already landed) or parks and is revived by
    /// it (a second Deadlock + Resume pair). Both shapes are correct;
    /// every recorded deadlock is recovered.
    @TestCase
    func test_pct_condition_external_notify(): Unit {
        println("Testing PCT mediated external condition notify...")

        let mx = Mutex()
        let flag = AtomicInt64(0)
        let value = AtomicInt64(0)
        mx.lock()
        let cond = mx.condition()
        mx.unlock()

        // Unmanaged thread (spawned outside the scenario window: its
        // spawn site absorbs, so it never registers): after the actor
        // parked on the condition (having released the mutex), it takes
        // the mutex, sets the flag, notifies and unlocks.
        let ext = spawn {
            sleep(Duration.millisecond * 200)
            mx.lock()
            flag.store(Int64(1))
            cond.notify()
            mx.unlock()
            0
        }

        let result = scenario("pct_condition_external")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(31337u64)
            .actor {
                mx.lock()
                cond.waitUntil({ => flag.load() == Int64(1) })
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

        var waits = 0
        var notifies = 0
        var unlocks = 0
        var blocks = 0
        var deadlocks = 0
        var resumes = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Wait => waits++
                case Notify => notifies++
                case Unlock => unlocks++
                case Block => blocks++
                case Deadlock => deadlocks++
                case Resume => resumes++
                case _ => ()
            }
        }
        // No actor-to-actor transfers (a lone actor) and no actor-side
        // notify/unlock; the condition park and (possibly) the contended
        // re-acquire record deadlocks that the external thread's notify
        // and unlock each revive with a stranded-token Resume.
        @Assert(waits == 0)
        @Assert(notifies == 0)
        @Assert(unlocks == 0)
        @Assert(blocks == 0)
        @Assert(deadlocks >= 1)
        @Assert(resumes == deadlocks)
    }

    /// ReadWriteLock: the views share one mediation key, so a reader
    /// holding the read lock forces the writer's acquire into a mediated
    /// Wait, and the reader's unlock flips it (an Unlock) — the retry
    /// probe then sorts write eligibility. Reader/writer exclusion holds
    /// throughout.
    @TestCase
    func test_pct_rwlock_mediated_handoff(): Unit {
        println("Testing PCT mediated ReadWriteLock handoff...")

        let rwl = ReadWriteLock()
        let data = AtomicInt64(0)
        let violations = AtomicInt64(0)
        let writers = AtomicInt64(0)
        let readers = AtomicInt64(0)

        let result = scenario("pct_rwlock_handoff")
            .mode(PCT)
            .priorityChangePoints(4)
            .iterations(1)
            .pctSeed(20260925u64)
            .actor {
                rwl.readLock.lock()
                if (readers.fetchAdd(1) > Int64(1)) {
                    violations.fetchAdd(1)
                }
                data.fetchAdd(1)
                readers.fetchSub(1)
                rwl.readLock.unlock()
                0
            }
            .actor {
                rwl.writeLock.lock()
                if (writers.fetchAdd(1) != Int64(0) || readers.load() != Int64(0)) {
                    violations.fetchAdd(1)
                }
                data.store(data.load() + Int64(10))
                writers.fetchSub(1)
                rwl.writeLock.unlock()
                0
            }
            .actor {
                rwl.readLock.lock()
                if (readers.fetchAdd(1) > Int64(1)) {
                    violations.fetchAdd(1)
                }
                data.fetchAdd(1)
                readers.fetchSub(1)
                rwl.readLock.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(violations.load() == 0)
        @Assert(data.load() == Int64(12))
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
        @Assert(waits == 1)
        @Assert(unlocks == 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
        @Assert(resumes == 0)
    }

    /// The deprecated ReentrantMutex rides the same Phase B protocol as
    /// Mutex (uncontended and same-thread reentrant acquisitions stay
    /// invisible through the tryLock probe; contended ones are mediated).
    @TestCase
    func test_pct_reentrant_mutex_mediation(): Unit {
        println("Testing PCT mediated ReentrantMutex...")

        let m = ReentrantMutex()
        let inSection = AtomicInt64(0)
        let violations = AtomicInt64(0)
        let rounds = 10

        let result = scenario("pct_reentrant_handoff")
            .mode(PCT)
            .priorityChangePoints(4)
            .iterations(1)
            .pctSeed(20260925u64)
            .actor {
                for (_ in 0..rounds) {
                    m.lock()
                    m.lock() // reentrant: invisible (probe succeeds)
                    let cur = inSection.fetchAdd(1)
                    if (cur != 0) {
                        violations.fetchAdd(1)
                    }
                    inSection.fetchAdd(-1)
                    m.unlock()
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
        @Assert(waits >= 1)
        @Assert(unlocks >= 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
        @Assert(resumes == 0)
    }
}
