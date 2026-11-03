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

var reps: Int64 = 17800000
var procs: Int64 = 16

let m = Monitor()

var count = 0

func worker(n: Int64): Unit {
    if (n == 0) {
        count += 1
        m.notify()
        return
    }
    var res = spawn {
        worker(n-1)
    }
}

func benchmarkCreateThreads(reps: Int64, procs: Int64) {
    for (i in 0..procs) {
        spawn { =>
            worker(reps / procs)
        }
    }

    m.lock()
    while (count < procs) {
        m.wait(timeout: Duration.millisecond)
    }
    m.unlock()
}

main(): Int64 {
    var startTime: DateTime
    var endTime: DateTime
    var perTime: Float64

    startTime = DateTime.now()
    benchmarkCreateThreads(reps, procs)
    endTime = DateTime.now()
    perTime = Float64((endTime - startTime).toNanoseconds())/Float64(reps)

    println("BenchmarkCreateThreadsParallel: " + perTime.format(".2") + " ns/op")

    return 0
}
