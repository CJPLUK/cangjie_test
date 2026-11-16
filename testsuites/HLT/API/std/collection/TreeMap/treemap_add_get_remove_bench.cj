/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 3
// EXEC: %compiler %cmp_opt -Woff unused %f -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args --bench

import std.collection.*
import std.runtime.*

const SIZE: Int64 = 200000

func permuteKey(i: Int64): Int64 {
    return (i * 48271) % SIZE
}

func buildMap(): TreeMap<Int64, Int64> {
    let map = TreeMap<Int64, Int64>()
    for (i in 0..SIZE) {
        let key = permuteKey(i)
        map.add(key, key)
    }
    return map
}

@Test
class TreeMapAddGetRemoveBenchmark {
    @Bench
    func add(): Unit {
        let map = TreeMap<Int64, Int64>()
        for (i in 0..SIZE) {
            let key = permuteKey(i)
            map.add(key, key)
        }
        let _ = blackBox(map.size)
    }

    @Bench
    func getExisting(): Unit {
        let map = buildMap()
        var checksum: Int64 = 0
        for (i in 0..SIZE) {
            checksum += map.get(permuteKey(i)).getOrThrow()
        }
        let _ = blackBox(checksum)
    }

    @Bench
    func getMissing(): Unit {
        let map = buildMap()
        var misses: Int64 = 0
        for (i in 0..SIZE) {
            if (map.get(SIZE + permuteKey(i)).isNone()) {
                misses++
            }
        }
        let _ = blackBox(misses)
    }

    @Bench
    func removeExisting(): Unit {
        let map = buildMap()
        var checksum: Int64 = 0
        for (i in 0..SIZE) {
            checksum += map.remove(permuteKey(i)).getOrThrow()
        }
        let _ = blackBox(checksum)
    }

    @Bench
    func removeMissing(): Unit {
        let map = buildMap()
        var misses: Int64 = 0
        for (i in 0..SIZE) {
            if (map.remove(SIZE + permuteKey(i)).isNone()) {
                misses++
            }
        }
        let _ = blackBox(misses)
    }
}
