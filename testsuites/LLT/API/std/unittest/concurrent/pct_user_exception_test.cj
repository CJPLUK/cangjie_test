/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it verifies that a user
// exception thrown by a wrapper-supplied closure (a Monitor.wait without
// holding the monitor; a Semaphore.acquire with an out-of-range amount)
// unwinds the failing actor's operation and fails the iteration with the
// user's own error: the coordinator lock is released and the actor state
// restored at the throw site, so the peer actor and the iteration drain
// complete instead of hanging, and the failure report names the actor and
// the exception. A mediated two-actor mutex ping-pong guards the protocol
// against regressions of that restructuring.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 3

// ASSERT: scan monitor_waiter
// ASSERT: scan IllegalSynchronizationStateException
// ASSERT: scan sem_overacquire
// ASSERT: scan Invalid argument 'amount'

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctUserExceptionTests {
    /// A condition wait without holding the monitor: the wrapper's inner
    /// release closure throws under the coordinator lock. The error is the
    /// actor's own — it unwinds the operation (recorded as its result) and
    /// the iteration fails with the user's exception in the actor failure
    /// details, while the peer actor still runs to completion: no hang,
    /// no protocol-failure misdiagnosis.
    @TestCase
    func test_pct_user_exception_unheld_monitor_wait(): Unit {
        println("Testing PCT user exception (unheld monitor wait)...")

        let mon = Monitor()

        let result = scenario("pct_user_unheld_wait")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(4711u64)
            .actor("monitor_waiter") {
                mon.wait() // not holding the monitor: the release closure throws
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
        @Assert(reportText.contains("monitor_waiter"))
        @Assert(reportText.contains("IllegalSynchronizationStateException"))
    }

    /// A semaphore acquire with an amount beyond the initial count: the
    /// wrapper's probe closure throws under the coordinator lock. Like the
    /// unheld wait, the error unwinds the actor's operation and surfaces as
    /// the iteration's failure with the user's exception; the peer actor
    /// completes, so run() returns instead of hanging.
    @TestCase
    func test_pct_user_exception_semaphore_amount(): Unit {
        println("Testing PCT user exception (semaphore amount out of range)...")

        let sem = Semaphore(1)

        let result = scenario("pct_user_sem_amount")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(815u64)
            .actor("sem_overacquire") {
                sem.acquire(amount: 2) // 2 > the initial count of 1: the probe throws
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
        @Assert(reportText.contains("sem_overacquire"))
        @Assert(reportText.contains("Invalid argument 'amount'"))
    }

    /// Control: ordinary mediated traffic still passes — every contended
    /// acquisition is a mediated Wait, every unlock with waiters an Unlock
    /// yield point, mutual exclusion holds, and no protocol failure is
    /// recorded. (Structurally identical to the mediated-handoff case of
    /// pct_mediated_test.cj, same seed and parameters.)
    @TestCase
    func test_pct_user_exception_control_handoff(): Unit {
        println("Testing PCT user exception control (mediated mutex handoff)...")

        let m = Mutex()
        let inSection = AtomicInt64(0)
        let violations = AtomicInt64(0)
        let rounds = 10

        let result = scenario("pct_user_control_handoff")
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
        println("Schedule: ${result.pctSchedule.getOrThrow().report()}")

        var waits = 0
        var unlocks = 0
        var blocks = 0
        for (ev in pctEvents(result.pctSchedule.getOrThrow())) {
            match (ev.kind) {
                case Wait => waits++
                case Unlock => unlocks++
                case Block => blocks++
                case _ => ()
            }
        }
        @Assert(waits >= 1)
        @Assert(unlocks >= 1)
        @Assert(blocks == 0)
    }
}
