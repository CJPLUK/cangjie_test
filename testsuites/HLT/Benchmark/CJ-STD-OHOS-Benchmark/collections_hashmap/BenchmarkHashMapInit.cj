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
public class Test_HashMap_Init_Capacity {
    @Bench
    func BenchmarkHashMapInitCapacity_Int64_N_16(): Unit {
        var arr = HashMap<Int64, Int64>()
    }

    @Bench
    func BenchmarkHashMapInitCapacity_Int64_N_128(): Unit {
        var arr = HashMap<Int64, Int64>(128)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_Int64_N_1024(): Unit {
        var arr = HashMap<Int64, Int64>(1024)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_Int64_N_8192(): Unit {
        var arr = HashMap<Int64, Int64>(8192)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_Int64_N_65536(): Unit {
        var arr = HashMap<Int64, Int64>(65536)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_Int64_N_1048576(): Unit {
        var arr = HashMap<Int64, Int64>(1048576)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_String_N_16(): Unit {
        var arr = HashMap<String, Int64>()
    }

    @Bench
    func BenchmarkHashMapInitCapacity_String_N_128(): Unit {
        var arr = HashMap<String, Int64>(128)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_String_N_1024(): Unit {
        var arr = HashMap<String, Int64>(1024)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_String_N_8192(): Unit {
        var arr = HashMap<String, Int64>(8192)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_String_N_65536(): Unit {
        var arr = HashMap<String, Int64>(65536)
    }

    @Bench
    func BenchmarkHashMapInitCapacity_String_N_1048576(): Unit {
        var arr = HashMap<String, Int64>(1048576)
    }
}

main(){
    let testInfo = Test_HashMap_Init_Capacity().asTestSuite().runBenchmarks().reportTo(RawStatsReporter())
    for(cases in testInfo) {
        println("${cases[0]}: ms = ${cases[1][0]/1000000.0}")
    }
}
