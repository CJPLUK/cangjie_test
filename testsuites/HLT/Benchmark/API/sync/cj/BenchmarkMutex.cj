/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %f -o %output

import std.sync.*
import std.time.*
import std.convert.*

func benchmarkMutex(work:Bool) {
    var mu: ReentrantMutex = ReentrantMutex()
    mu.lock()
    mu.unlock()
    var foo: Int64 = 0
    if(work == true) {
        for(i in 0..100:1) {
            foo = foo*2
            foo = foo/2
        }
    }
}

main(): Int64 {
    var startTime = DateTime.now()
    benchmarkMutex(false)
    var endTime = DateTime.now()
    var perTime = Float64((endTime - startTime).toNanoseconds())

    println("BenchmarkMutex: " + perTime.format(".2") + " ns/op")
    return 0
}

