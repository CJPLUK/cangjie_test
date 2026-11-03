/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 --no-sub-pkg %f -o %output
// RUN-EXEC: %export cjHeapSize=512mb && %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan ms
// TIMEOUT: 1800
import std.convert.*
import std.io.*
import std.time.*
import std.convert.*
import std.collection.*

let reps = 100000
let nums = [4096, 512, 64, 8]

func setUp(num: Int64): ArrayList<String> {
    var floatArr = ArrayList<String>()
    for (i in 0..num) {
        let str = i.toString() + "." + i.toString()
        floatArr.add(str)
    }
    return floatArr
}

func benchmarkStr2Float64(floatArr: ArrayList<String>) {
    for (n in 0..reps) {
        for (i in floatArr) {
            Float64.parse(i)
        }
    }
}

main(): Int64 {
    var startTime = DateTime.now()
    for (num in nums) {
        var floatArr = setUp(num)
        benchmarkStr2Float64(floatArr)
    }
    var endTime = DateTime.now()
    var perTime = Float64((endTime - startTime).toNanoseconds())

    println("BenchmarkStr2Float64: ms = ${perTime / 1000000.0}")
    return 0

}
