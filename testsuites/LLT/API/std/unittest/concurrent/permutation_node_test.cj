/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle %f %cmp_utest_opt %enableO2 -o %output
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 2

// Tests the thread safety and sequential consistency of PermutationNode's
// lock-free data structures (copy-on-write child array + AtomicOptionReference
// cachedResult) using the stdx.unittest.concurrent scenario framework itself.
//
// This file lives in package stdx.concurrent_test_util (same module as
// stdx.unittest.concurrent), so it can access protected types like
// PermutationNode and its protected cachedResult field. The scenario
// framework's linearizability validator serves as the consistency oracle:
// concurrent operations on PermutationNode must produce results consistent
// with some sequential ordering.

package stdx.concurrent_test_util

import stdx.unittest.concurrent.*
import std.unittest.testmacro.*

@Test
class PermutationNodeConcurrencyTests {
    // Concurrent ensureChild calls on a shared PermutationNode. Multiple
    // actors call ensureChild with the same and different opIds. The
    // linearizability validator verifies that the returned operation IDs are
    // consistent with a sequential ordering — ensureChild(X) always returns
    // a child whose operation is Some(X), regardless of interleaving.
    @TestCase
    func testEnsureChildLinearizable(): Unit {
        let result = scenario("pn_ensure_child")
            .withState { => PermutationNode(operation: None, depth: 0) }
            .consistencyModel(Linearizability)
            .actor { node => node.ensureChild(0).operation ?? -1 }
            .actor { node => node.ensureChild(0).operation ?? -1 }
            .actor { node => node.ensureChild(1).operation ?? -1 }
            .actor { node => node.ensureChild(1).operation ?? -1 }
            .actor { node => node.ensureChild(2).operation ?? -1 }
            .iterations(50)
            .build()
            .run()
        println(result.report())
        @Assert(result.passed)
    }

    // Concurrent compareAndSwap on cachedResult. Each actor tries to CAS the
    // cached result from None to Some(value). Exactly one CAS should succeed
    // (return true → 1); the rest fail (return false → 0). The linearizability
    // validator verifies this is consistent with a sequential ordering where
    // the winner goes first.
    @TestCase
    func testCachedResultCasLinearizable(): Unit {
        let result = scenario("pn_cached_result_cas")
            .withState { => PermutationNode(operation: Some(0), depth: 0) }
            .consistencyModel(Linearizability)
            .actor { node =>
                let won = node.cachedResult.compareAndSwap(None, Some(execResultOf({ => 0 })))
                if (won) { 1 } else { 0 }
            }
            .actor { node =>
                let won = node.cachedResult.compareAndSwap(None, Some(execResultOf({ => 1 })))
                if (won) { 1 } else { 0 }
            }
            .actor { node =>
                let won = node.cachedResult.compareAndSwap(None, Some(execResultOf({ => 2 })))
                if (won) { 1 } else { 0 }
            }
            .actor { node =>
                let won = node.cachedResult.compareAndSwap(None, Some(execResultOf({ => 3 })))
                if (won) { 1 } else { 0 }
            }
            .iterations(50)
            .build()
            .run()
        println(result.report())
        @Assert(result.passed)
    }
}
