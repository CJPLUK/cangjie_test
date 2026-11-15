/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: this file MUST be compiled WITHOUT --cj-pct — it verifies the
// compilation-contract guard: activating PCT mode in an uninstrumented
// binary fails fast with a clear error instead of hanging on invisible
// blocking.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 1

import stdx.unittest.concurrent.*

@Test
class PctUninstrumentedTests {
    /// The binary is not compiled with --cj-pct, so the PCT marker is absent
    /// and the coordinator's activate() must refuse to start the iteration
    /// with the documented error rather than letting actor blocking hang.
    @TestCase
    func test_pct_uninstrumented_binary_rejected(): Unit {
        println("Testing PCT uninstrumented binary guard...")

        var thrown = false
        try {
            let result = scenario("pct_uninstrumented_guard")
                .mode(PCT)
                .iterations(1)
                .actor {
                    ()
                }
                .build()
                .run()
            @Assert(!result.passed)
        } catch (e: Exception) {
            thrown = true
            let msg = e.message
            @Assert(msg.contains("--cj-pct"))
            println("Guard error: ${msg}")
        }
        @Assert(thrown)
    }
}
