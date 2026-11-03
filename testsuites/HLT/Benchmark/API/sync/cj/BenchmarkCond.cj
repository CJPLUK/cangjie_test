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
import std.collection.*

func setCond(reps: Int64, waiters: Int64, m: Monitor): Unit {
    var id = 0
    
    for (j in 0..reps) {
        m.lock()
        if(id == -1){
            m.unlock()
            break
        }
        id++
        if(id == waiters+1){
            id = 0
            m.notifyAll()
        } else {
            m.wait()
            ()
        }
        m.unlock()
    }
    m.lock()
    id = -1
    m.notifyAll()
    m.unlock()
}

func benchmarkCond(reps: Int64, waiters: Int64) {
   let m = Monitor()
   var futs: ArrayList<Future<Unit>> = ArrayList<Future<Unit>>()
   for (i in 0..(waiters+1)) {
      let fut: Future<Unit> =spawn { =>
                                      setCond(reps, waiters, m)
                                   }
      futs.add(fut)
   }
   for (k in 0..(waiters+1)) {
       futs[k].get()
   }
}

func timeBenchmarkCond(reps: Int64, waiters: Int64): Unit {
    var startTime = DateTime.now()
    benchmarkCond(reps, waiters)
    var endTime = DateTime.now()

    var perTime: Float64 = Float64((endTime - startTime).toNanoseconds())/Float64(reps)
    println("BenchmarkCond" + "${waiters}: " + perTime.format(".2") + " ns/op")
}

main(): Int64 {
    var items: Array<Array<Int64>> = [[1887612, 1], [610618, 2], [291266, 4], [184987, 8], [88647, 16], [42540, 32]]

    for (item in items) {
        timeBenchmarkCond(item[0], item[1])
    }

    return 0
}

