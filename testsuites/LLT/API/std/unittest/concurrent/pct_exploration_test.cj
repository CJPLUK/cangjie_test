/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 1

import stdx.unittest.concurrent.*
import std.collection.ArrayList

@Test
class PctExplorationTests {
    var orderLog = ArrayList<Int64>()
    // First element of each iteration's order; never reset, appended by the
    // per-iteration verify block (main thread only).
    var firstSeen = ArrayList<Int64>()

    /// PCT assigns a fresh random priority permutation per iteration, so the
    /// initial release must explore both actor orderings across iterations.
    /// (With independent random seeds the probability of seeing only one
    /// order in 30 iterations is 2^-29 — negligible.)
    @TestCase
    func test_pct_explores_both_orders(): Unit {
        println("Testing that PCT explores both actor orderings...")

        let result = scenario("pct_order_exploration")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(30)
            .reset { => orderLog = ArrayList<Int64>() }
            .actor { => orderLog.add(1) }
            .actor { => orderLog.add(2) }
            .verify { =>
                firstSeen.add(orderLog[0])
                orderLog.size == 2
            }
            .build()
            .run()

        @Assert(result.passed)

        var sawOneFirst = false
        var sawTwoFirst = false
        for (v in firstSeen) {
            if (v == 1) {
                sawOneFirst = true
            } else if (v == 2) {
                sawTwoFirst = true
            }
        }
        @Assert(sawOneFirst)
        @Assert(sawTwoFirst)
    }
}
