/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

import stdx.unittest.concurrent.*
import std.sync.AtomicInt64
import std.collection.concurrent.ConcurrentLinkedQueue

class Box {
    public var v: Int64 = 0
    public init() {}
}

// Demonstrates the typed ScenarioBuilder<S> API: state initialization is done
// via the .withState(factory) builder method on a ScenarioBuilder<Unit> returned
// by scenario(name). The per-iteration state is produced by the factory and
// passed to each operation lambda. No module-level shared mutable variable is
// required, which makes parallel iteration execution safe (each iteration
// creates its own isolated state).
@Test
class StateFactoryTests {
    @TestCase
    func testAtomicCounterStateFactory(): Unit {
        // Each iteration creates a fresh AtomicInt64(0). Two actors fetchAdd +1
        // and -1 against it; consistency validation re-executes operations
        // against per-DFS-restart fresh AtomicInt64 instances.
        let result = scenario("atomic_counter_state_factory")
            .withState { => AtomicInt64(0) }
            .consistencyModel(Linearizability)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchSub(1) }
            .iterations(10)
            .build()
            .run()

        println(result.report())
        @Assert(result.passed)
    }

    @TestCase
    func testQueueStateFactory(): Unit {
        // Each iteration creates a fresh ConcurrentLinkedQueue<Int64>. The
        // operation lambdas receive the queue as a parameter rather than
        // capturing a shared module-level var, so iterations could safely run
        // in parallel.
        let result = scenario("queue_state_factory")
            .withState { => ConcurrentLinkedQueue<Int64>() }
            .consistencyModel(Linearizability)
            .actorWithOps([
                operation("add1") { q => q.add(1) },
                operation("add2") { q => q.add(2) },
            ])
            .actorWithOps([
                operation("remove") { q => q.remove() ?? -1 },
            ])
            .iterations(10)
            .build()
            .run()

        println(result.report())
        @Assert(result.passed)
    }

    @TestCase
    func testVerifyWithState(): Unit {
        // The verify block also receives the per-iteration state. After all
        // actors finish adding, the queue should contain exactly 3 elements.
        // (Three independent adds are commutative, so linearizability trivially
        // holds — this exercises the verify-with-state path without coupling
        // to racy remove semantics.)
        let result = scenario("queue_verify_state_factory")
            .withState { => ConcurrentLinkedQueue<Int64>() }
            .actor { q => q.add(1) }
            .actor { q => q.add(2) }
            .actor { q => q.add(3) }
            .verify { q => q.size == 3 }
            .iterations(10)
            .build()
            .run()

        println(result.report())
        @Assert(result.passed)
    }

    @TestCase
    func testDataRaceStateFactoryNotLinearizable(): Unit {
        // A non-atomic counter is shared between actors via the state factory.
        // Because each iteration gets a fresh counter, the data race is
        // contained to a single iteration and the validator can reliably
        // detect non-linearizability.
        //
        // Runs in the default parallel mode (withState => parallel). The pool
        // size leaves threadCount processors idle so they can steal actors
        // from the spawning processor's local queue, preserving hardware-level
        // race detection sensitivity close to sequential mode.
        let result = scenario("data_race_state_factory")
            .withState { => Box() }
            .consistencyModel(Linearizability)
            .actor { b => b.v += 1; b.v }
            .actor { b => b.v -= 1; b.v }
            .iterations(2000)
            .build()
            .run()

        println(result.report())
        @Assert(!result.passed)
    }
}
