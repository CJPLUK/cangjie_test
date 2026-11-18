/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it pins the
// lock-held status check of Condition.waitUntil (std checks the status
// BEFORE the first predicate evaluation: an unheld caller gets the
// IllegalSynchronizationStateException and the predicate never runs).
// The non-actor path delegates to the underlying std condition, so
// plain code outside a scenario observes exactly std's behavior; a PCT
// actor passes the same check through the wrapper's status probe
// before its mediated loop, so the exception surfaces as the actor's
// operation result and fails the iteration. A correctly-held
// waitUntil handoff (peer locks, notifies and sets the flag) still
// completes through the mediated protocol.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 3

// ASSERT: scan unheld_waituntil
// ASSERT: scan IllegalSynchronizationStateException

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class WaituntilStatusTests {
    /// Non-actor caller (plain test-body code, outside any scenario):
    /// the wrapper delegates to the underlying std condition, which
    /// throws the IllegalSynchronizationStateException before the first
    /// predicate evaluation — the waitUntil must not return normally
    /// and the predicate must not run.
    @TestCase
    func test_waituntil_status_before_predicate_nonactor(): Unit {
        println("Testing waitUntil status check (non-actor, before predicate)...")

        let m = Mutex()
        m.lock()
        let c = m.condition()
        m.unlock()
        let ran = AtomicInt64(0)

        var threwIsse = false
        try {
            c.waitUntil({ => ran.store(1); true })
            @Assert(false) // unreachable: the status check throws first
        } catch (e: Exception) {
            threwIsse = e is IllegalSynchronizationStateException
        }
        @Assert(threwIsse)
        @Assert(ran.load() == 0) // the predicate never ran
    }

    /// A PCT actor calling waitUntil without holding the owner mutex:
    /// the wrapper's status probe (the raw inner notify) throws the
    /// IllegalSynchronizationStateException, which unwinds the actor's
    /// operation and fails the iteration with the user's exception in
    /// the report — the peer actor still completes, so run() returns.
    @TestCase
    func test_waituntil_status_actor_unheld(): Unit {
        println("Testing waitUntil status check (actor, unheld)...")

        let mx = Mutex()
        mx.lock()
        let cond = mx.condition()
        mx.unlock()

        let result = scenario("waituntil_unheld_actor")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(2301u64)
            .actor("unheld_waituntil") {
                cond.waitUntil({ => true }) // the owner lock is NOT held: ISSE first
                0
            }
            .actor {
                0
            }
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.pctSchedule.isSome())
        let reportText = result.report().toString()
        println(reportText)
        @Assert(reportText.contains("unheld_waituntil"))
        @Assert(reportText.contains("IllegalSynchronizationStateException"))
    }

    /// Control: an actor holding the owner mutex runs waitUntil against
    /// a flag a peer actor raises under the same lock with a notifyAll —
    /// the status probe passes side-effect-free and the mediated
    /// handoff completes (the condition park and the contended Mesa
    /// re-acquire are Wait events, the notifyAll and the final unlock
    /// are their yield points; no runtime parks, no deadlock).
    @TestCase
    func test_waituntil_control_held_handoff(): Unit {
        println("Testing waitUntil control (held lock, mediated handoff)...")

        let mx = Mutex()
        let flag = AtomicInt64(0)
        let value = AtomicInt64(0)
        mx.lock()
        let cond = mx.condition()
        mx.unlock()

        let result = scenario("waituntil_held_handoff")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4242u64)
            .actor {
                mx.lock()
                cond.waitUntil({ => flag.load() == Int64(1) })
                value.store(Int64(7))
                mx.unlock()
                0
            }
            .actor {
                mx.lock()
                flag.store(Int64(1))
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
        // Condition park + contended Mesa re-acquire; the status probe
        // is invisible (a raw inner call, no coordinator interaction).
        @Assert(waits == 2)
        @Assert(notifyAlls == 1)
        @Assert(unlocks == 1)
        @Assert(blocks == 0)
        @Assert(deadlocks == 0)
    }
}
