/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %cmp_utest_opt %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %run %run_opt %output %run_utest_opt %run_args --bench

import std.time.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
@Test
@Configure[minDuration: Duration.second * 3, measurement: TimeNow(TimeUnit.Nanos)]
@Configure[warmup: Duration.second]
public class Test_HashMap_Clone {
    var hashmap_16 = HashMap<Int64, Int64>(16)
    var hashmap_128 = HashMap<Int64, Int64>(128)
    var hashmap_1024 = HashMap<Int64, Int64>(1024)
    var hashmap_65536 = HashMap<Int64, Int64>(65536)

    public override func beforeAll(): Unit {
        for (i in 0..16) {
            hashmap_16.add(i, i)
        }
        for (i in 0..128) {
            hashmap_128.add(i, i)
        }
        for (i in 0..1024) {
            hashmap_1024.add(i, i)
        }
        for (i in 0..65536) {
            hashmap_65536.add(i, i)
        }
    }

    @Bench
    func BenchmarkHashMapClone_N_16(): Unit {
        var hashmap = hashmap_16.clone()
    }

    @Bench
    func BenchmarkHashMapClone_N_128(): Unit {
        var hashmap = hashmap_128.clone()
    }

    @Bench
    func BenchmarkHashMapClone_N_1024(): Unit {
        var hashmap = hashmap_1024.clone()
    }

    @Bench
    func BenchmarkHashMapClone_N_65536(): Unit {
        var hashmap = hashmap_65536.clone()
    }
}

main(){
    let testInfo = Test_HashMap_Clone().asTestSuite().runBenchmarks().reportTo(RawStatsReporter())
    for(cases in testInfo) {
        println("${cases[0]}: ms = ${cases[1][0]/1000000.0}")
    }
}
