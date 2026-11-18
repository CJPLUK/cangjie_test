/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %export cjHeapSize=16gb && %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 1
// ASSERT: scan Consistency validation failed
// ASSERT: scan NOT serializable
// ASSERT: scan Ordering: no constraints
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan add1
// ASSERT: scan peek
// ASSERT: scan add3
// ASSERT: scan remove
// ASSERT: scan ✗
// ASSERT: scan ≠
// ASSERT: scan-not Executed operations:

import stdx.unittest.concurrent.*
import std.collection.concurrent.ConcurrentLinkedQueue

// todo: when the bug is fixed, we need to copy the bugged version of the queue here as a test that we can detect such bugs.
@Test
func testQueueSerializable(): Unit {
    let result = scenario("queue_serializable_bug")
        .consistencyModel(Serializability)
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
