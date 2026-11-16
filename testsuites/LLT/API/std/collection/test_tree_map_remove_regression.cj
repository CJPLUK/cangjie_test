/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.collection.*

@Test
class TreeMapRemoveRegressionTest {
    func expectOrderedEntries(map: TreeMap<Int64, Int64>, firstKey: Int64, endKey: Int64): Unit {
        var expectedKey = firstKey
        for ((key, value) in map) {
            @Expect(key, expectedKey)
            @Expect(value, expectedKey * 10)
            expectedKey++
        }
        @Expect(expectedKey, endKey)
    }

    @TestCase
    func removeFromEmptyAndMissingKey(): Unit {
        let map = TreeMap<Int64, Int64>()
        @Expect(map.remove(1), None<Int64>)
        @Expect(map.size, 0)

        map.add(all: [(1, 10), (2, 20), (3, 30)])
        @Expect(map.remove(-1), None<Int64>)
        @Expect(map.remove(4), None<Int64>)
        @Expect(map.size, 3)
        @Expect(map.get(2), Some(20))
    }

    @TestCase
    func removeAllInSequentialAndReverseOrder(): Unit {
        let sequential = TreeMap<Int64, Int64>()
        for (i in 0..512) {
            sequential.add(i, i * 2)
        }
        for (i in 0..512) {
            @Expect(sequential.remove(i), Some(i * 2))
            @Expect(sequential.get(i), None<Int64>)
        }
        @Expect(sequential.isEmpty(), true)

        let reverse = TreeMap<Int64, Int64>()
        for (i in 0..512) {
            reverse.add(i, i)
        }
        for (i in 0..512) {
            let key = 511 - i
            @Expect(reverse.remove(key), Some(key))
        }
        @Expect(reverse.size, 0)
    }

    @TestCase
    func removeKeepsSurvivorsOrderedAndReachable(): Unit {
        let map = TreeMap<Int64, Int64>()
        for (i in 0..1000) {
            map.add(i, i)
        }
        for (i in 0..1000 : 2) {
            @Expect(map.remove(i), Some(i))
        }

        var previous = -1
        var count = 0
        for ((key, value) in map) {
            @Expect(key > previous, true)
            @Expect(key % 2, 1)
            @Expect(value, key)
            previous = key
            count++
        }
        @Expect(count, 500)
        @Expect(map.size, 500)
    }

    @TestCase
    func addOverwriteAndReaddAfterDrainPreserveMapContract(): Unit {
        let map = TreeMap<Int64, Int64>()
        @Expect(map.add(7, 70), None<Int64>)
        @Expect(map.add(7, 71), Some(70))
        @Expect(map.size, 1)
        @Expect(map.get(7), Some(71))

        @Expect(map.remove(7), Some(71))
        @Expect(map.isEmpty(), true)
        @Expect(map.add(7, 72), None<Int64>)
        @Expect(map.get(7), Some(72))
    }

    @TestCase
    func removeFirstDrainsLeftEdgeAndPreservesOrderWhileRebalancing(): Unit {
        let empty = TreeMap<Int64, Int64>()
        @Expect(empty.removeFirst().isNone(), true)

        let single = TreeMap<Int64, Int64>()
        single.add(7, 70)
        let only = single.removeFirst().getOrThrow()
        @Expect(only[0], 7)
        @Expect(only[1], 70)
        @Expect(single.isEmpty(), true)
        @Expect(single.removeFirst().isNone(), true)

        let map = TreeMap<Int64, Int64>()
        for (i in 0..512) {
            map.add(i, i * 10)
        }
        for (i in 0..512) {
            let first = map.removeFirst().getOrThrow()
            @Expect(first[0], i)
            @Expect(first[1], i * 10)
            if (i % 32 == 31) {
                expectOrderedEntries(map, i + 1, 512)
            }
        }
        @Expect(map.isEmpty(), true)
        @Expect(map.removeFirst().isNone(), true)
    }

    @TestCase
    func removeLastDrainsRightEdgeAndPreservesOrderWhileRebalancing(): Unit {
        let empty = TreeMap<Int64, Int64>()
        @Expect(empty.removeLast().isNone(), true)

        let single = TreeMap<Int64, Int64>()
        single.add(7, 70)
        let only = single.removeLast().getOrThrow()
        @Expect(only[0], 7)
        @Expect(only[1], 70)
        @Expect(single.isEmpty(), true)
        @Expect(single.removeLast().isNone(), true)

        let map = TreeMap<Int64, Int64>()
        for (i in 0..512) {
            map.add(i, i * 10)
        }
        for (i in 0..512) {
            let last = map.removeLast().getOrThrow()
            let expectedKey = 511 - i
            @Expect(last[0], expectedKey)
            @Expect(last[1], expectedKey * 10)
            if (i % 32 == 31) {
                expectOrderedEntries(map, 0, expectedKey)
            }
        }
        @Expect(map.isEmpty(), true)
        @Expect(map.removeLast().isNone(), true)
    }

    @TestCase
    func removeIfKeepsSuccessorsOrderedAndCanDrainTree(): Unit {
        let empty = TreeMap<Int64, Int64>()
        empty.removeIf({_, _ => true})
        @Expect(empty.isEmpty(), true)

        let single = TreeMap<Int64, Int64>()
        single.add(7, 70)
        single.removeIf({key, _ => key == 7})
        @Expect(single.isEmpty(), true)

        let map = TreeMap<Int64, Int64>()
        for (i in 0..512) {
            map.add(i, i * 10)
        }
        map.removeIf({key, _ => key % 3 == 0})

        var previous = -1
        var count = 0
        for ((key, value) in map) {
            @Expect(key > previous, true)
            @Expect(key % 3 != 0, true)
            @Expect(value, key * 10)
            previous = key
            count++
        }
        @Expect(count, 341)
        @Expect(map.size, 341)

        map.removeIf({_, _ => true})
        @Expect(map.isEmpty(), true)
        @Expect(map.removeFirst().isNone(), true)
        @Expect(map.removeLast().isNone(), true)
    }

    @TestCase
    func removeIfRechecksSuccessorsDuringConsecutiveInteriorDeletion(): Unit {
        let map = TreeMap<Int64, Int64>()
        for (i in 0..512) {
            map.add(i, i * 10)
        }

        map.removeIf({key, _ => key >= 100 && key < 400})
        @Expect(map.size, 212)

        var expectedKey = 0
        for ((key, value) in map) {
            if (expectedKey == 100) {
                expectedKey = 400
            }
            @Expect(key, expectedKey)
            @Expect(value, expectedKey * 10)
            expectedKey++
        }
        @Expect(expectedKey, 512)
        @Expect(map.get(99), Some(990))
        @Expect(map.get(100), None<Int64>)
        @Expect(map.get(399), None<Int64>)
        @Expect(map.get(400), Some(4000))

        map.removeIf({key, _ => key < 400})
        expectOrderedEntries(map, 400, 512)
        map.removeIf({_, _ => true})
        @Expect(map.isEmpty(), true)
    }
}
