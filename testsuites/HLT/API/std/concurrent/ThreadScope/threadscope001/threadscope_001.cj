/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// EXEC: %compiler %cmp_opt %cmp_utest_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.collection.ArrayList
import std.concurrent.*
import std.sync.*
import std.time.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class Test_ThreadScope_001 {
    private func requireUnit(value: Unit): Unit {
        return value
    }

    @TestCase
    public func addReturnsUnit(): Unit {
        ThreadScope<Int64, Unit> {
            group =>
                requireUnit(group.add { 1 })
        }
    }

    @TestCase
    public func aggregatesResultsFromMultipleSubtasks(): Unit {
        let sum = ThreadScope<Int64, Int64> {
            group =>
                group.add { 10 }
                group.add { 20 }
                group.add { 30 }

                var total = 0
                for (value in group) {
                    total += value
                }
                total
        }

        @Expect(sum, 60)
    }

    @TestCase
    public func singleSubtaskFailurePropagatesException(): Unit {
        var caughtMessage = ""
        try {
            ThreadScope<Int64, Unit> {
                group =>
                    group.add { 1 }
                    group.add {
                        throw Exception("subtask failed")
                    }
                    group.add { 3 }
            }
        } catch (e: Exception) {
            caughtMessage = e.message
        }

        @Expect(caughtMessage, "subtask failed")
    }

    @TestCase
    public func childFailureCancelsCooperativeSiblingsBeforeRethrow(): Unit {
        let cancellationObserved = AtomicBool(false)
        var caughtMessage = ""

        try {
            ThreadScope<Unit, Unit> {
                group =>
                    group.add {
                        throw Exception("child failed")
                    }
                    sleep(Duration.millisecond * 20)
                    group.add {
                        var attempts: Int64 = 0
                        var done = false
                        while (!done && attempts < 200) {
                            if (Thread.currentThread.hasPendingCancellation) {
                                cancellationObserved.store(true)
                                done = true
                            } else {
                                attempts += 1
                                sleep(Duration.millisecond * 5)
                            }
                        }
                    }
            }
        } catch (e: Exception) {
            caughtMessage = e.message
        }

        @Expect(caughtMessage, "child failed")
        @Assert(cancellationObserved.load())
    }

    @TestCase
    public func scopeWaitsForAllSubtasksBeforeReturning(): Unit {
        let finishedCount = AtomicInt64(0)

        ThreadScope<Unit, Unit> {
            group =>
                group.add {
                    sleep(Duration.millisecond * 30)
                    finishedCount.fetchAdd(1)
                }
                group.add {
                    sleep(Duration.millisecond * 60)
                    finishedCount.fetchAdd(1)
                }
                group.add {
                    sleep(Duration.millisecond * 90)
                    finishedCount.fetchAdd(1)
                }
        }

        @Expect(finishedCount.load(), 3)
    }

    @TestCase
    public func cancelAllRequestsCancellationForRunningTasks(): Unit {
        let cancellationObserved = AtomicBool(false)

        ThreadScope<Unit, Unit> {
            group =>
                group.add {
                    while (!Thread.currentThread.hasPendingCancellation) {
                        sleep(Duration.millisecond * 10)
                    }
                    cancellationObserved.store(true)
                }

                sleep(Duration.millisecond * 50)
                group.cancelAll()
        }

        @Assert(cancellationObserved.load())
    }

    @TestCase
    public func iteratorReturnsResultsInCompletionOrder(): Unit {
        let results = ThreadScope<Int64, ArrayList<Int64>> {
            group =>
                group.add {
                    sleep(Duration.millisecond * 60)
                    1
                }
                group.add {
                    sleep(Duration.millisecond * 10)
                    2
                }
                group.add {
                    sleep(Duration.millisecond * 30)
                    3
                }

                let collected = ArrayList<Int64>()
                for (value in group) {
                    collected.add(value)
                }
                collected
        }

        @Expect(results.size, 3)
        @Expect(results[0], 2)
        @Expect(results[1], 3)
        @Expect(results[2], 1)
    }

    @TestCase
    public func emptyScopeReturnsNormally(): Unit {
        let result = ThreadScope<Unit, Int64> {
            _ =>
                42
        }

        @Expect(result, 42)
    }

    @TestCase
    public func middleSubtaskFailsWhileOthersSucceed(): Unit {
        let taskCount = 4
        let finishedCount = AtomicInt64(0)
        var caughtMessage = ""

        try {
            ThreadScope<Int64, Unit> {
                group =>
                    group.add {
                        sleep(Duration.millisecond * 20)
                        finishedCount.fetchAdd(1)
                        1
                    }
                    group.add {
                        sleep(Duration.millisecond * 50)
                        finishedCount.fetchAdd(1)
                        throw Exception("middle task failed")
                    }
                    group.add {
                        sleep(Duration.millisecond * 80)
                        finishedCount.fetchAdd(1)
                        3
                    }
                    group.add {
                        sleep(Duration.millisecond * 110)
                        finishedCount.fetchAdd(1)
                        4
                    }
            }
        } catch (e: Exception) {
            caughtMessage = e.message
        }

        @Expect(caughtMessage, "middle task failed")
        @Expect(finishedCount.load(), Int64(taskCount))
    }

    @TestCase
    public func allSubtasksFailAndScopeWaitsForAll(): Unit {
        let taskCount = 4
        let finishedCount = AtomicInt64(0)

        var caughtException = false
        try {
            ThreadScope<Unit, Unit> {
                group =>
                    group.add {
                        try {
                            sleep(Duration.millisecond * 30)
                            throw Exception("task 0 failed")
                        } finally {
                            finishedCount.fetchAdd(1)
                        }
                    }
                    group.add {
                        try {
                            sleep(Duration.millisecond * 60)
                            throw Exception("task 1 failed")
                        } finally {
                            finishedCount.fetchAdd(1)
                        }
                    }
                    group.add {
                        try {
                            sleep(Duration.millisecond * 90)
                            throw Exception("task 2 failed")
                        } finally {
                            finishedCount.fetchAdd(1)
                        }
                    }
                    group.add {
                        try {
                            sleep(Duration.millisecond * 120)
                            throw Exception("task 3 failed")
                        } finally {
                            finishedCount.fetchAdd(1)
                        }
                    }
            }
        } catch (e: Exception) {
            caughtException = true
        }

        @Assert(caughtException)
        @Expect(finishedCount.load(), Int64(taskCount))
    }
}
