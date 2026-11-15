/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: it pins the Serializability validation guard's error path: a
// history with more than SERIALIZABILITY_OP_LIMIT (10) operations is
// rejected with the "practical limit" validation error instead of
// entering the factorial permutation DFS — and the error message itself
// must render for ANY operation count: the permutation count is only
// computed where it fits Int64 (factorial(20) is the largest that
// does), so a 21-operation history (factorial(21) overflows Int64)
// surfaces the same validation error rather than an arithmetic
// overflow exception. The guard returns the error result without
// running the DFS, so both runs are fast.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 2

import stdx.unittest.concurrent.*
import std.sync.AtomicInt64

/** Seven single-operation fetchAdds for one actor (named per actor). */
func serializabilityLimitOps(prefix: String): Array<Operation<AtomicInt64>> {
    Array<Operation<AtomicInt64>>(7, { i =>
        operation<Int64, AtomicInt64>("${prefix}_op${i}") { c =>
            let _ = c.fetchAdd(1)
            0
        }
    })
}

@Test
class SerializabilityLimitTests {
    /// Eleven single-op actors: one operation past the practical limit —
    /// the guard fires (no DFS), the iteration fails with the guard's
    /// validation error, and the rendered verdict names the limit.
    @TestCase
    func test_serializability_over_limit_guard(): Unit {
        println("Testing Serializability over-limit guard (11 operations)...")

        let result = scenario("serializability_limit_11")
            .consistencyModel(Serializability)
            .withState { => AtomicInt64(0) }
            .actor(11) { c: AtomicInt64 =>
                let _ = c.fetchAdd(1)
                0
            }
            .iterations(1)
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.consistencyValidations.size == 1)
        let text = result.consistencyValidations[0].report().toString()
        println(text)
        @Assert(text.contains("practical limit of 10"))
    }

    /// Twenty-one operations (3 actors x 7 ops): factorial(21) overflows
    /// Int64, which used to make the guard's own error path throw an
    /// arithmetic overflow instead of the intended validation error.
    /// The guard must surface the practical-limit error with no trace of
    /// an overflow anywhere in the rendered verdict.
    @TestCase
    func test_serializability_21_ops_no_overflow(): Unit {
        println("Testing Serializability over-limit guard (21 operations)...")

        let result = scenario("serializability_limit_21")
            .consistencyModel(Serializability)
            .withState { => AtomicInt64(0) }
            .actorWithOps(serializabilityLimitOps("a"))
            .actorWithOps(serializabilityLimitOps("b"))
            .actorWithOps(serializabilityLimitOps("c"))
            .iterations(1)
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.consistencyValidations.size == 1)
        let text = result.consistencyValidations[0].report().toString()
        println(text)
        @Assert(text.contains("practical limit of 10"))
        @Assert(!text.contains("overflow"))
        @Assert(!text.contains("Overflow"))
    }
}
