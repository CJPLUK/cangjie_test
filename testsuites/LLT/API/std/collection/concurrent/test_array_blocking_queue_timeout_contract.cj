/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

import std.collection.concurrent.*
import std.sync.*
import std.time.*

/*
 * Regression tests for the timeout CONTRACT of ArrayBlockingQueue's timed waits
 * (review finding on PR 1860 / lost-wakeup fix follow-up).
 *
 * Defect: while the timed wait helpers now recheck the condition after
 * registering the waiter (lost-wakeup fix), the loop re-entered
 * Monitor.wait(timeout:) with the FULL caller timeout each round and ignored
 * wait's Bool return. When the condition never becomes true the loop never
 * exits and add(element, timeout:)/remove(timeout:) never return at their
 * deadline; even when the condition eventually becomes true, each round
 * re-waits a full timeout, so the deadline is overshot.
 *
 * Contract under test (Cangjie std lib, matching java.util.concurrent
 * semantics): add(element, timeout) returns false and remove(timeout) returns
 * None at approximately the caller's deadline when the condition cannot be
 * satisfied, and never later than the deadline in the scenarios below.
 *
 * Scenarios are single-threaded and deterministic: no rival thread ever
 * satisfies the condition, so any return at the deadline exercises the
 * deadline-exit path of the wait loop, and the late-producer scenario proves a
 * late element cannot be observed past the deadline.
 */

const DEADLINE_MS: Int64 = 300
const LATE_PRODUCER_MS: Int64 = 600
// generous scheduling headroom (runtime is a cooperative scheduler)
const BUDGET_MS: Int64 = 2000

@Test
class AbqTimeoutContractTest {
    // A timed remove on an eternally empty queue must return None ~at the
    // deadline instead of re-waiting full timeouts forever.
    @TestCase
    func testTimedRemoveOnEmptyQueueReturnsAtDeadline(): Unit {
        let q = ArrayBlockingQueue<Int64>(1)
        let start = MonoTime.now()
        let r = q.remove(Duration.millisecond * DEADLINE_MS)
        let elapsedMs = (MonoTime.now() - start).toMilliseconds()
        // value contract
        @Assert(r.isNone())
        // deadline contract: returned, and within budget (deadline + headroom)
        @Assert(elapsedMs < BUDGET_MS)
    }

    // A timed add on an eternally full queue must return false ~at the
    // deadline instead of re-waiting full timeouts forever.
    @TestCase
    func testTimedAddOnFullQueueReturnsAtDeadline(): Unit {
        let q = ArrayBlockingQueue<Int64>(1)
        @Assert(q.tryAdd(1))
        let start = MonoTime.now()
        let r = q.add(2, Duration.millisecond * DEADLINE_MS)
        let elapsedMs = (MonoTime.now() - start).toMilliseconds()
        // value contract
        @Assert(!r)
        // deadline contract
        @Assert(elapsedMs < BUDGET_MS)
    }

    // An element arriving AFTER the deadline must not be observed by a remove
    // whose deadline already passed: proves the loop exits at the deadline
    // instead of continuing to wait (deadline overshoot regression).
    @TestCase
    func testLateProducerNotObservedPastDeadline(): Unit {
        let q = ArrayBlockingQueue<Int64>(1)
        let producer = spawn {
            sleep(Duration.millisecond * LATE_PRODUCER_MS)
            q.add(7)
        }
        let start = MonoTime.now()
        let r = q.remove(Duration.millisecond * DEADLINE_MS)
        let elapsedMs = (MonoTime.now() - start).toMilliseconds()
        producer.get()
        // the element arrived at ~600ms, the deadline is 300ms: the call must
        // return None ~at the deadline, never the late element.
        @Assert(r.isNone())
        @Assert(elapsedMs < LATE_PRODUCER_MS)
    }
}
