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

var reps: Int64 = 610618
var waiters: Int64 = 2
var id = 0

func benchmarkCond2(rep:Int64,waiter: Int64) {
   let m=Monitor()
   var futs: ArrayList<Future<Unit>> = ArrayList<Future<Unit>>()
   for (i in 0..(waiter+1))
   {
      let fut: Future<Unit> =spawn { =>
                                      benchmarkCond(rep,waiter,m)
                                   }
      futs.add(fut)
   }
   for (k in 0..(waiter+1)) {
       futs[k].get()
   }
}

public func benchmarkCond(rep:Int64,waiter: Int64, m:Monitor):Unit
{
    for (j in 0..rep) {
        m.lock()
        if(id == -1){
            m.unlock()
            break
        }
        id++
        if(id == waiter+1){
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

main(): Int64 {
    var startTime: DateTime
    var endTime: DateTime
    var perTime: Float64
    startTime = DateTime.now()
    benchmarkCond2(reps,waiters)
    endTime = DateTime.now()
    perTime = Float64((endTime - startTime).toNanoseconds())/Float64(reps)

    println("BenchmarkCond2: " + perTime.format(".2") + " ns/op")
    return 0
}
