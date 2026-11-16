/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %import-cangjie-stdx -O2 %overflow_wrapping --no-sub-pkg %cmp_utest_opt -Woff=all %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run_stdx %output %run_utest_opt %run_args --bench --no-color

import std.time.*
import std.collection.*
import std.runtime.*

@Test
@Configure[minDuration: Duration.second * 3]
@Measure[TimeNow(Nanos)]
@Configure[warmup: Duration.second]
public class Test_Forin_Range {
    var sum = 0
    var _count = 0
    var size = 0
    let _range = [1000, 1000000, 1000000000]

    @BeforeEach
    public func GenerateSize(): Unit {
        size = _range[_count % _range.size]
        _count += 1
    }

    @AfterEach
    public func Reset(): Unit {
        sum = 0
    }

    @Bench
    func BenchmarkForinRangeWhere_UnClosed_N_1000(): Unit {
        for (j in 0..size where j % 2 == 1) {
            sum += j
        }
        blackBox(sum)
    }

    @Bench
    func BenchmarkForinRangeWhere_UnClosed_N_1000000(): Unit {
        for (j in 0..size where j % 2 == 1) {
            sum += j
        }
        blackBox(sum)
    }

    @Bench
    func BenchmarkForinRangeWhere_UnClosed_N_1000000000(): Unit {
        for (j in 0..size where j % 2 == 1) {
            sum += j
        }
        blackBox(sum)
    }

    @Bench
    func BenchmarkForinRangeWhere_Closed_N_1000(): Unit {
        for (j in 0..=size where j % 2 == 1) {
            sum += j
        }
        blackBox(sum)
    }

    @Bench
    func BenchmarkForinRangeWhere_Closed_N_1000000(): Unit {
        for (j in 0..=size where j % 2 == 1) {
            sum += j
        }
        blackBox(sum)
    }

    @Bench
    func BenchmarkForinRangeWhere_Closed_N_1000000000(): Unit {
        for (j in 0..=size where j % 2 == 1) {
            sum += j
        }
        blackBox(sum)
    }
}


