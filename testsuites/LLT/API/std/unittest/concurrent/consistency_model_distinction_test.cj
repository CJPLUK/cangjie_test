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
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

// Consistency model distinction tests.
//
// On Cangjie's strong memory model, all hardware-level outcomes are SC-consistent,
// making it impossible to observe outcomes that distinguish serializability from SC
// or SC from linearizability in practice. These tests verify the structural
// differences between models:
//
// - Serializability: no partial order constraints (empty order)
// - SequentialConsistency: per-actor ordering constraints only
// - Linearizability: per-actor + VC happens-before constraints
//
// Model hierarchy: Linearizability (strongest) ⊇ SC ⊇ Serializability (weakest)
// If a stronger model accepts an outcome, a weaker model must also accept it.

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.AtomicInt64

@Test
class ConsistencyModelDistinctionTests {
    var x = 0
    var y = 0
    var counter = 0

    @TestCase
    func testModelHierarchyWithAtomicCounter(): Unit {
        let linCounter = AtomicInt64(0)
        let scCounter = AtomicInt64(0)
        let serCounter = AtomicInt64(0)

        let linResult = scenario("hierarchy_lin")
            .consistencyModel(Linearizability)
            .reset { => linCounter.store(0) }
            .actor({ => linCounter.fetchAdd(1) })
            .actor({ => linCounter.fetchSub(1) })
            .iterations(100)
            .build()
            .run()

        let scResult = scenario("hierarchy_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => scCounter.store(0) }
            .actor({ => scCounter.fetchAdd(1) })
            .actor({ => scCounter.fetchSub(1) })
            .iterations(100)
            .build()
            .run()

        let serResult = scenario("hierarchy_ser")
            .consistencyModel(Serializability)
            .reset { => serCounter.store(0) }
            .actor({ => serCounter.fetchAdd(1) })
            .actor({ => serCounter.fetchSub(1) })
            .iterations(100)
            .build()
            .run()

        println("Linearizability: ${linResult.report()}")
        println("SC: ${scResult.report()}")
        println("Serializability: ${serResult.report()}")

        @Assert(linResult.passed)
        @Assert(scResult.passed)
        @Assert(serResult.passed)
        @Assert(!linResult.passed || scResult.passed)
        @Assert(!scResult.passed || serResult.passed)
    }

    @TestCase
    func testTwoFieldRegisterPartialOrderStructure(): Unit {
        let scResult = scenario("twofield_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => x = 0; y = 0 }
            .actorWithOps([
                operation("setX", { => x = 1; x }),
                operation("getY", { => y }),
            ])
            .actorWithOps([
                operation("setY", { => y = 1; y }),
                operation("getX", { => x }),
            ])
            .iterations(1)
            .build()
            .run()

        let serResult = scenario("twofield_ser")
            .consistencyModel(Serializability)
            .reset { => x = 0; y = 0 }
            .actorWithOps([
                operation("setX", { => x = 1; x }),
                operation("getY", { => y }),
            ])
            .actorWithOps([
                operation("setY", { => y = 1; y }),
                operation("getX", { => x }),
            ])
            .iterations(1)
            .build()
            .run()

        println("SC result: ${scResult.report()}")
        println("Serializability result: ${serResult.report()}")

        @Assert(scResult.passed)
        @Assert(serResult.passed)

        let scEdges = countPredecessorEdges(scResult)
        let serEdges = countPredecessorEdges(serResult)

        println("SC predecessor edges: ${scEdges}, operations: ${getPartialOrderSize(scResult)}")
        println("Serializability predecessor edges: ${serEdges}, operations: ${getPartialOrderSize(serResult)}")

        @Assert(scEdges > 0)
        @Assert(serEdges == 0)
        @Assert(scEdges > serEdges)
        @Assert(!scResult.passed || serResult.passed)
    }

    @TestCase
    func testDataRaceAllModelsReject(): Unit {
        let linResult = scenario("race_lin")
            .consistencyModel(Linearizability)
            .reset { => counter = 0 }
            .actor({ => counter += 1; counter })
            .actor({ => counter -= 1; counter })
            .iterations(1000)
            .build()
            .run()

        let scResult = scenario("race_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => counter = 0 }
            .actor({ => counter += 1; counter })
            .actor({ => counter -= 1; counter })
            .iterations(1000)
            .build()
            .run()

        let serResult = scenario("race_ser")
            .consistencyModel(Serializability)
            .reset { => counter = 0 }
            .actor({ => counter += 1; counter })
            .actor({ => counter -= 1; counter })
            .iterations(1000)
            .build()
            .run()

        println("Linearizability: ${linResult.report()}")
        println("SC: ${scResult.report()}")
        println("Serializability: ${serResult.report()}")

        @Assert(!linResult.passed)
        @Assert(!scResult.passed)
        @Assert(!serResult.passed)
    }

    @TestCase
    func testLinearizabilityMoreConstrainedThanSC(): Unit {
        let linResult = scenario("constraints_lin")
            .consistencyModel(Linearizability)
            .reset { => x = 0; y = 0 }
            .actorWithOps([
                operation("setX", { => x = 1; x }),
                operation("getY", { => y }),
            ])
            .actorWithOps([
                operation("setY", { => y = 1; y }),
                operation("getX", { => x }),
            ])
            .iterations(100)
            .build()
            .run()

        let scResult = scenario("constraints_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => x = 0; y = 0 }
            .actorWithOps([
                operation("setX", { => x = 1; x }),
                operation("getY", { => y }),
            ])
            .actorWithOps([
                operation("setY", { => y = 1; y }),
                operation("getX", { => x }),
            ])
            .iterations(100)
            .build()
            .run()

        println("Linearizability: ${linResult.report()}")
        println("SC: ${scResult.report()}")

        @Assert(linResult.passed)
        @Assert(scResult.passed)

        let linEdges = countPredecessorEdges(linResult)
        let scEdges = countPredecessorEdges(scResult)

        println("Linearizability predecessor edges: ${linEdges}")
        println("SC predecessor edges: ${scEdges}")

        @Assert(linEdges >= scEdges)
        @Assert(!linResult.passed || scResult.passed)
    }
}