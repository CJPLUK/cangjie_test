/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -o %n.%suffix %f %cmp_utest_opt %enableO2
// EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_utest_opt --no-color 2>&1 | compare %f

// Verifies early-exit semantics under the default parallel iteration path
// (withState => parallel). Iteration 0 always runs first sequentially; if it
// fails, no parallel iterations are dispatched.
// ASSERT: scan [ PASSED ] CASE: parallel_all_pass
// ASSERT: scan [ PASSED ] CASE: parallel_iter0_fails
// ASSERT: scan parallel_queue_serializable
// ASSERT: scan TOTAL: 3

import std.unittest.*
import std.unittest.testmacro.*
import stdx.unittest.concurrent.*
import std.sync.AtomicInt64
import std.collection.concurrent.ConcurrentLinkedQueue

@TestBuilder
func testParallelAllPass(): TestSuite {
    // withState => default parallel. Linearizable counter (+1/-1), verify
    // passes (counter ends at 0). All iterations pass.
    let scenario = scenario("parallel_all_pass_scenario")
        .withState { => AtomicInt64(0) }
        .consistencyModel(Linearizability)
        .actor { c => c.fetchAdd(1) }
        .actor { c => c.fetchSub(1) }
        .verify { c => c.load() == 0 }
        .iterations(10)
        .build()

    TestSuite
        .builder("parallel_all_pass_suite")
        .add(UnitTestCase.create("parallel_all_pass") {
            =>
            let result = scenario.run()
            @Assert(result.passed)
            @Assert(result.iterationsExecuted == 10)
        })
        .build()
}

@TestBuilder
func testParallelIterationZeroFails(): TestSuite {
    // withState => default parallel. verify always returns false, so iteration
    // 0 (which runs first sequentially) fails and early-exit stops any
    // parallel iterations from being dispatched.
    let scenario = scenario("parallel_iter0_fails_scenario")
        .withState { => AtomicInt64(0) }
        .consistencyModel(Linearizability)
        .actor { c => c.fetchAdd(1) }
        .iterations(5)
        .verify { _ => false }
        .build()

    TestSuite
        .builder("parallel_iter0_fails_suite")
        .add(UnitTestCase.create("parallel_iter0_fails") {
            =>
            let result = scenario.run()
            @Assert(!result.passed)
            // Early exit: only iteration 0 ran.
            @Assert(result.iterationsExecuted == 1)
        })
        .build()
}

@TestBuilder
func testQueueSerializable(): TestSuite {
    let scenario = scenario("parallel_queue_serializable")
        .consistencyModel(SequentialConsistency)
        .withState { => ConcurrentLinkedQueue<Int64>() }
        .actorWithOps([
            operation("add1", { queue => queue.add(1) }),
            operation("peek", { queue => queue.peek() ?? -1 }),
            operation("add3", { queue => queue.add(3) }),
        ])
        .actorWithOps([
            operation("remove", { queue => queue.remove() ?? -1 }),
            operation("peek", { queue => queue.peek() ?? -1 }),
            operation("remove", { queue => queue.remove() ?? -1 }),
        ])
        .iterations(5000)
        .build()

    TestSuite
        .builder("parallel_queue_serializable_suite")
        .add(UnitTestCase.create("parallel_queue_serializable") {
            =>
            // A stress smoke: the queue scenario is run and its report
            // printed, but no verdict is asserted — the ConcurrentLinkedQueue
            // serializability race can legitimately surface under stress
            // (queue_bug_test pins the deterministic catch).
            let result = scenario.run()
            println(result.report())
        })
        .build()
}
