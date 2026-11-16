/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -O2 --no-sub-pkg %f -o %output
// RUN-EXEC: %export cjHeapSize=512mb && %run_stdx %output %run_args 2>&1 | compare %f
// ASSERT: scan ms
// TIMEOUT: 1800
import stdx.encoding.json.*
import std.io.*
import std.time.*
import std.convert.*
import std.collection.*

let reps = 100000
let nums = [4096, 512, 64, 8]

func setUp(num: Int64): JsonArray {
    var buf = ArrayList<JsonValue>()
    for (i in 0..num) {
        buf.add(JsonInt(i))
    }
    var jsonArray = JsonArray(buf)
    return jsonArray
}

func benchmarkJsonArray2JsonStr(jsonArr: JsonArray) {
    for (i in 0..reps) {
        jsonArr.toJsonString()
    }
}

func timeBenchmarkJsonArray2JsonStr(num: Int64) {
    var jsonArray = setUp(num)

    benchmarkJsonArray2JsonStr(jsonArray)
}

main(): Int64 {
    var startTime = DateTime.now()
    for (num in nums) {
        timeBenchmarkJsonArray2JsonStr(num)
    }
    var endTime = DateTime.now()
    var perTime = Float64((endTime - startTime).toNanoseconds())

    println("BenchmarkJsonArray2JsonStr: ms = ${perTime / 1000000.0}")
    return 0
}
