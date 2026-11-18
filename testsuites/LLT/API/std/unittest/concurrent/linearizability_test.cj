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
// ASSERT: scan PASSED: 2

import stdx.unittest.concurrent.*
import std.sync.AtomicInt64
import std.collection.concurrent.ConcurrentLinkedQueue

@Test
class LinearizabilityTests {
    var counter = 0
    var queue = ConcurrentLinkedQueue<Int64>()
    
    @TestCase
    func testAtomicCounterLinearizable(): Unit {
        let atomicCounter = AtomicInt64(0)
        
        let result = scenario("atomic_counter_linearizable")
            .consistencyModel(Linearizability)
            .reset { => atomicCounter.store(0) }
            .actor({ => atomicCounter.fetchAdd(1) })
            .actor({ => atomicCounter.fetchSub(1) })
            .iterations(10)
            .build()
            .run()
        
        println(result.report())
        @Assert(result.passed)
    }
    
    @TestCase
    func testDataRaceNotLinearizable(): Unit {
        let result = scenario("data_race_not_linearizable")
            .consistencyModel(Linearizability)
            .reset { => counter = 0 }
            .actor({ => counter += 1; counter })
            .actor({ => counter -= 1; counter })
            .iterations(2000)
            .build()
            .run()
        
        println(result.report())
        @Assert(!result.passed)
    }
    
}