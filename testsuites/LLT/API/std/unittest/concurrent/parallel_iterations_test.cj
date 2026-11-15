/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -o %output %f %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 5

import stdx.unittest.concurrent.*
import std.sync.AtomicInt64

class Box {
    public var v: Int64 = 0
    public init() {}
}

// Verifies parallel iteration execution (the default when .withState is used)
// produces correct results, the explicit sequential/parallel override API
// works, and the shared ConsistencyValidator memoisation tree is not
// corrupted under concurrent validate() calls.
@Test
class ParallelIterationsTests {
    // (a) Default parallel via withState: a linearizable multi-iteration
    // scenario should pass. Each iteration gets a fresh AtomicInt64 so
    // iterations are fully isolated and parallel execution is safe.
    @TestCase
    func testParallelDefaultPasses(): Unit {
        let result = scenario("parallel_default_passes")
            .withState { => AtomicInt64(0) }
            .consistencyModel(Linearizability)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchSub(1) }
            .iterations(50)
            .build()
            .run()
        println(result.report())
        @Assert(result.passed)
    }

    // (b) Explicit sequential override: .parallelIterations(false) forces the
    // original sequential loop even though withState was used.
    @TestCase
    func testExplicitSequentialOverride(): Unit {
        let result = scenario("explicit_sequential_override")
            .withState { => AtomicInt64(0) }
            .consistencyModel(Linearizability)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchSub(1) }
            .iterations(20)
            .parallelIterations(false)
            .build()
            .run()
        println(result.report())
        @Assert(result.passed)
    }

    // (c) Explicit parallel override: .parallelIterations(true) is redundant
    // with the withState default but verifies the API compiles and runs.
    @TestCase
    func testExplicitParallelOverride(): Unit {
        let result = scenario("explicit_parallel_override")
            .withState { => AtomicInt64(0) }
            .consistencyModel(Linearizability)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchSub(1) }
            .iterations(20)
            .parallelIterations(true)
            .build()
            .run()
        println(result.report())
        @Assert(result.passed)
    }

    // (d) Parallel stress: many iterations hammering the shared validator
    // memoisation tree concurrently. If the lock-free tree (ConcurrentHashMap +
    // AtomicOptionReference + CAS) were corrupted, results would be
    // inconsistent.
    @TestCase
    func testParallelStressManyIterations(): Unit {
        let result = scenario("parallel_stress_many")
            .withState { => AtomicInt64(0) }
            .consistencyModel(Linearizability)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchSub(1) }
            .iterations(200)
            .build()
            .run()
        println(result.report())
        @Assert(result.passed)
    }

    // (e) Parallel execution still detects non-linearizability: each
    // iteration gets a fresh Box with non-atomic v; two actors race on it.
    // The pool size leaves threadCount processors idle so they can steal
    // actors from the spawning processor's local queue, placing the two
    // actors of one iteration on different cores — required for hardware-
    // level race detection (the data race has no safepoints in the operation
    // body, so it can only manifest as a hardware-level race).
    @TestCase
    func testParallelDetectsNonLinearizability(): Unit {
        let result = scenario("parallel_detects_nonlin")
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
