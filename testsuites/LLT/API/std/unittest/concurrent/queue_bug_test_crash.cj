/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE-1: %export cjHeapSize=16gb && %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color --death-aware | compare %f
// ASSERT: scan REASON: Crashed
// ASSERT: scan ERROR: 1


import stdx.unittest.concurrent.*
import std.collection.concurrent.ConcurrentLinkedQueue

struct Data <: Equatable<Data> {
    Data(let v: Box<Int64>) {}

    public operator func ==(other: Data): Bool {
        v.value == other.v.value
    }
}

// todo: when the bug is fixed, we need to copy the bugged version of the queue here as a test that we can detect such bugs.
@Test
func testQueueSerializable(): Unit {
    // The queue race usually crashes the process before the run completes
    // (use-after-free through the concurrently removed Box) — the framework
    // reports the crashed case (--death-aware). If it ever completes without
    // crashing, the consistency failure below still fails the scenario.
    let result = scenario("queue_serializable_bug")
        .consistencyModel(Serializability)
        .withState { => ConcurrentLinkedQueue<Data>() }
        .actorWithOps([
            operation("add1", { queue => queue.add(Data(Box(1))) }),
            operation("peek", { queue => queue.peek() }),
            operation("add3", { queue => queue.add(Data(Box(3))) }),
        ])
        .actorWithOps([
            operation("remove", { queue => queue.remove() }),
            operation("peek", { queue => queue.peek() }),
            operation("remove", { queue => queue.remove() }),
        ])
        .iterations(50000)
        .build()
        .run()

    if (!result.passed) {
        println(result.report())
        for (v in result.consistencyValidations) {
            println(v.report())
        }
    }
    @Assert(!result.passed)
}
