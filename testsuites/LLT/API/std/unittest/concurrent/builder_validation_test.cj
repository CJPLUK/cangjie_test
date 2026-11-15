/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — the control case runs
// a real PCT window. It pins the scenario builder's withState transition
// contract: the state-receiving configuration (after/verify closures,
// sequentialSpec) must be rejected rather than silently dropped when the
// builder is retyped, while the state-type-agnostic reset block carries
// over (it runs before the state factory on every iteration, and the
// auto consistency validator's restarts invoke it too). It also pins the
// PCT-only contract of pctSeed/replaySchedule: build() rejects them in
// DPOR and Stress mode (a fixed seed forces exactly one iteration, which
// would cap the exploration/repetition budget), and a PCT-mode fixed-seed
// scenario builds and runs exactly one iteration.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 8

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.AtomicInt64

/** Mutable per-iteration state for the typed-scenario cases. */
class BuilderValidationBox {
    public var v: Int64 = 0
}

@Test
class BuilderValidationTests {
    /// An after block configured before withState is rejected: its
    /// closure receives the previous state type and cannot be retyped.
    @TestCase
    func test_withState_rejects_after_block(): Unit {
        println("Testing withState rejection (after block)...")
        var thrown = false
        try {
            let _ = scenario("with_state_after_rejected")
                .after { => () }
                .withState { => BuilderValidationBox() }
        } catch (e: IllegalArgumentException) {
            thrown = true
            @Assert(e.message.contains("before after/verify blocks"))
            println("Rejected as expected: ${e.message}")
        }
        @Assert(thrown)
    }

    /// A verify block configured before withState is rejected for the
    /// same reason (an S-typed closure).
    @TestCase
    func test_withState_rejects_verify_block(): Unit {
        println("Testing withState rejection (verify block)...")
        var thrown = false
        try {
            let _ = scenario("with_state_verify_rejected")
                .verify { => true }
                .withState { => BuilderValidationBox() }
        } catch (e: IllegalArgumentException) {
            thrown = true
            @Assert(e.message.contains("before after/verify blocks"))
            println("Rejected as expected: ${e.message}")
        }
        @Assert(thrown)
    }

    /// A sequentialSpec configured before withState is rejected: its
    /// captured reference implementation re-executes operations against
    /// the pre-withState state type.
    @TestCase
    func test_withState_rejects_sequential_spec(): Unit {
        println("Testing withState rejection (sequentialSpec)...")
        var thrown = false
        try {
            let _ = scenario("with_state_spec_rejected")
                .sequentialSpec<Int64>(
                    { => 0 },
                    { state: Int64, _: OperationInvocation =>
                        execResultOf<Int64>({ => state + 1 })
                    }
                )
                .withState { => BuilderValidationBox() }
        } catch (e: IllegalArgumentException) {
            thrown = true
            @Assert(e.message.contains("before sequentialSpec"))
            println("Rejected as expected: ${e.message}")
        }
        @Assert(thrown)
    }

    /// A reset block configured before withState carries over: it runs
    /// at the start of every iteration (zeroing the shared counter, so
    /// the final value reflects one isolated iteration, not an
    /// accumulation) and before every auto-validator restart (the
    /// spec-shape run keeps the validator on and the reset still fires
    /// at least once per iteration).
    @TestCase
    func test_withState_carries_reset_block(): Unit {
        println("Testing withState reset-block carry-over...")

        // Deterministic shape: sequential iterations, no validator —
        // the reset count and the shared counter's final value are
        // exact (3 resets; the last iteration leaves exactly one
        // increment on the zeroed counter).
        let sharedCounter = AtomicInt64(12345)
        let resetRuns = AtomicInt64(0)
        let result = scenario("with_state_reset_carries")
            .reset { =>
                let _ = resetRuns.fetchAdd(1)
                sharedCounter.store(0)
            }
            .withState { => BuilderValidationBox() }
            .actor { b: BuilderValidationBox =>
                b.v += 1
                let _ = sharedCounter.fetchAdd(1)
                b.v
            }
            .verify { b: BuilderValidationBox => b.v == 1 }
            .iterations(3)
            .parallelIterations(false)
            .consistencyModel(NoValidation)
            .build()
            .run()
        @Assert(result.passed)
        @Assert(resetRuns.load() == 3)
        @Assert(sharedCounter.load() == 1)
        println("Deterministic run: resetRuns=${resetRuns.load()} shared=${sharedCounter.load()}")

        // Spec shape (auto validator on, default parallel iterations):
        // the reset still fires at least once per iteration.
        let resetRuns2 = AtomicInt64(0)
        let result2 = scenario("with_state_reset_validator")
            .reset { =>
                let _ = resetRuns2.fetchAdd(1)
                ()
            }
            .withState { => BuilderValidationBox() }
            .actor { b: BuilderValidationBox => b.v += 1; b.v }
            .verify { b: BuilderValidationBox => b.v == 1 }
            .iterations(3)
            .build()
            .run()
        @Assert(result2.passed)
        @Assert(resetRuns2.load() >= 3)
        println("Validator run: resetRuns=${resetRuns2.load()}")
    }

    /// Regression pins for the pre-existing withState rejects: a second
    /// withState throws, and withState after actors throws (existing
    /// Unit-typed actors cannot be retyped).
    @TestCase
    func test_withState_preexisting_rejects(): Unit {
        println("Testing withState pre-existing rejects...")

        var doubleThrown = false
        try {
            let _ = scenario("with_state_double")
                .withState { => BuilderValidationBox() }
                .withState { => BuilderValidationBox() }
        } catch (e: IllegalArgumentException) {
            doubleThrown = true
            @Assert(e.message.contains("only be called once"))
            println("Double withState rejected as expected: ${e.message}")
        }
        @Assert(doubleThrown)

        var afterActorsThrown = false
        try {
            let _ = scenario("with_state_after_actors")
                .actor { => 0 }
                .withState { => BuilderValidationBox() }
        } catch (e: IllegalArgumentException) {
            afterActorsThrown = true
            @Assert(e.message.contains("before adding actors"))
            println("withState after actors rejected as expected: ${e.message}")
        }
        @Assert(afterActorsThrown)
    }

    /// pctSeed in DPOR mode is rejected at build() time: a fixed seed
    /// forces exactly one iteration, which would cap the whole schedule
    /// exploration budget.
    @TestCase
    func test_pctSeed_rejected_in_dpor_mode(): Unit {
        println("Testing pctSeed rejection in DPOR mode...")
        var thrown = false
        try {
            let _ = scenario("pct_seed_dpor_rejected")
                .mode(DPOR)
                .pctSeed(1u64)
                .actor { => 0 }
                .build()
        } catch (e: IllegalArgumentException) {
            thrown = true
            @Assert(e.message.contains("rejected in DPOR mode"))
            println("Rejected as expected: ${e.message}")
        }
        @Assert(thrown)
    }

    /// pctSeed in the default Stress mode is rejected at build() time
    /// for the same reason (it would pin the run to one repetition).
    @TestCase
    func test_pctSeed_rejected_in_stress_mode(): Unit {
        println("Testing pctSeed rejection in Stress mode...")
        var thrown = false
        try {
            let _ = scenario("pct_seed_stress_rejected")
                .pctSeed(1u64)
                .actor { => 0 }
                .build()
        } catch (e: IllegalArgumentException) {
            thrown = true
            @Assert(e.message.contains("rejected in Stress mode"))
            println("Rejected as expected: ${e.message}")
        }
        @Assert(thrown)
    }

    /// Control: pctSeed in PCT mode builds and runs exactly one
    /// iteration with the fixed seed's schedule recorded.
    @TestCase
    func test_pctSeed_control_pct_mode(): Unit {
        println("Testing pctSeed control in PCT mode...")

        let counter = AtomicInt64(0)
        let result = scenario("pct_seed_control")
            .mode(PCT)
            .priorityChangePoints(0)
            .pctSeed(42u64)
            .actor { => let _ = counter.fetchAdd(1); 0 }
            .actor { => let _ = counter.fetchAdd(1); 0 }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.iterationsExecuted == 1)
        @Assert(counter.load() == 2)
        @Assert(result.pctSchedule.isSome())
        @Assert(pctScheduleSeed(result.pctSchedule.getOrThrow()) == 42u64)
        println("Control run: iterations=${result.iterationsExecuted} counter=${counter.load()}")
    }
}
