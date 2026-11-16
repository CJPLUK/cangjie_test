/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: ./../../API/asan
// EXEC: %compiler %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %cmp_opt %f asan.%middle -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Stress tests for monitors
// TODO: need to be combined with other tests after llvmgc update monitor implementation

import std.sync.*
import std.collection.*
import std.random.*

import asan.*

// naive implementation
class CountDownLatch {
   var permits: UInt64
   let m: Monitor = Monitor()

   init(p: UInt64) { permits = p }

   func countDown(): Unit {
      synchronized(m) {
        if (permits == 0) {
           throw Exception("Negative permits")
        }
        permits = permits - 1
        m.notifyAll()
      }
   }

   func await(): Unit {
      synchronized(m) {
        while (permits != 0) { m.wait() }
      }
   }
}

var test1CommonState: Int64 = 0
func testContended(m: ReentrantMutex) {
    println("Test contended mutex")
    test1CommonState = 0

    let THREADS = 100
    let INNER_WORK = 10000

    let latch = CountDownLatch(1)

    let list = ArrayList<Future<Unit>>()
    for (i in 0..THREADS) {
        let f = spawn { =>
            latch.await()
            for (j in 0..INNER_WORK) {
              synchronized(m) {
                test1CommonState = test1CommonState + 1
              }
            }
        }
        list.add(f)
    }

    latch.countDown()
    for (f in list) {
        f.get()
    }

    let expect = THREADS * INNER_WORK
    if (test1CommonState != expect) {
        throw Exception("testContended failed: got ${test1CommonState} but expected ${expect}")
    }

    println("Success")
}

class PairData {
  var counter: Int64 = 0
  var turn   : Int64 = 0
}

func getTurn(data: PairData) {
   let x = data.turn
   if (x <  0) { throw Exception("Negative turn") }
   if (x >= 2) { throw Exception("Unexpected turn ${x}") }
   return x
}


func iterate(m: Monitor, data: PairData, id: Int64, limit: Int64): Unit {
     synchronized(m) {
       while(true) {
         while(getTurn(data) != id) {
//         print("${id}: wait on ${queueId}, turn ${getTurn(data)}\n")
           m.wait()
         }

         let s = data.counter
         data.counter = s + 1
         if (getTurn(data) == 0) {
            data.turn = 1
         } else {
            data.turn = 0
         }
//         print("${id}: notify ${queueId}, turn ${getTurn(data)}\n")
         m.notify()
         if (s >= limit - 2) { break }
       }
     }
}

func createPair(m: Monitor, limit: Int64) {
    let data = PairData()
    let f0 = spawn { =>       iterate(m, data, 0, limit)    }
    let f1 = spawn { =>       iterate(m, data, 1, limit)    }
    return (f0, f1, data)
}

func testM() {
    println("Test ping pong of 2 coroutines on monitor")
    let LIMIT = 10000

    let m = Monitor()

    let (f0, f1, data) = createPair(m, LIMIT)
    f0.get()
    f1.get()

    if (data.counter != LIMIT) {
       throw Exception("Unexpected: counter = ${data.counter} but expected ${LIMIT}")
    } else {
       println("Success")
    }
}

func iterate(m: MultiConditionMonitor, data: PairData, id: Int64, limit: Int64, queueId: ConditionID): Unit {
     synchronized(m) {
       while(true) {
         while(getTurn(data) != id) {
//         print("${id}: wait on ${queueId}, turn ${getTurn(data)}\n")
           m.wait(queueId)
         }

         let s = data.counter
         data.counter = s + 1
         if (getTurn(data) == 0) {
            data.turn = 1
         } else {
            data.turn = 0
         }
//         print("${id}: notify ${queueId}, turn ${getTurn(data)}\n")
         m.notify(queueId)
         if (s >= limit - 2) { break }
       }
     }
}

func createPair(m: MultiConditionMonitor, limit: Int64, queueId: ConditionID) {
    let data = PairData()
    let f0 = spawn { =>       iterate(m, data, 0, limit, queueId)    }
    let f1 = spawn { =>       iterate(m, data, 1, limit, queueId)    }
    return (f0, f1, data)    
}

func testMM1() {
    println("Test ping pong of 2 coroutines on same multi condition monitor, single wait queue")
    let LIMIT = 10000

    let m = MultiConditionMonitor()
    var cid: ConditionID
    synchronized(m) {
      cid = m.newCondition()
    }

    let (f0, f1, data) = createPair(m, LIMIT, cid)
    f0.get()
    f1.get()

    if (data.counter != LIMIT) {
       throw Exception("Unexpected: counter = ${data.counter} but expected ${LIMIT}")
    } else {
       println("Success")
    }    
}

func testMM2() {
    let PAIRS = 100
    let LIMIT = 100000
    println("Test ping pong of ${PAIRS} pairs on same multi condition monitor, different wait queues")

    let m = MultiConditionMonitor()

    let list = ArrayList<Future<Bool>>()
    for (i in 0..PAIRS) {
        let f = spawn { =>
            var qid: ConditionID
            synchronized(m) {
              qid = m.newCondition()
            }
//            print("start pair on queue ${qid}\n")

            let (x, y, data) = createPair(m, LIMIT, qid)
            x.get()
            y.get()
            return data.counter == LIMIT
        }
        list.add(f)
    }

    for (f in list) {
       let s = f.get()
       if (s == false) {
          throw Exception("Unexpected: one of pairs counted with error")
       }
    }

    println("Success")
}

class Pair {
  let monIdx = AtomicInt64(0)
  let role = AtomicInt64(0)

  let monitors = [Monitor(), Monitor()]

  func notifyMon(m : Monitor) {
    synchronized(m) {
      m.notify()
    }
  }

  func test(iter: Int64) {
    let idx = monIdx.fetchAdd(1)

    let o1 = monitors[idx]
    let o2 = monitors[idx ^ 1]

    synchronized(o1) {
      let consumer = (role.fetchAdd(1) == 0)

      if (consumer) {
        for (cnt in 0..iter) {
          o1.wait()
          notifyMon(o2)      
        }
      } else {
        for (cnt in 0..iter) {
          notifyMon(o2)
          o1.wait()
        }
      }
    }
  }
}

func testSynchProdCons() {
    let nPairs = 1
    let nIter = 1000000

    let startLatch = CountDownLatch(1)
    let iterForPair = nIter / nPairs
    let workers = ArrayList<Future<Unit>>()

    println("Test SynchProdCons: ${nIter} iterations for ${nPairs} thread pairs")

    for (i in 0..nPairs) {
      let pair = Pair()
      workers.add(spawn{ =>
          startLatch.await()
          pair.test(iterForPair)
      })
      workers.add(spawn{ =>
          startLatch.await()
          pair.test(iterForPair)
      })
    }

    startLatch.countDown()

    for (f in workers) {
      f.get()
    }
    println("Success")
}

main(): Int64 {
   try {
      let rm : ReentrantMutex        = ReentrantMutex()
      let m  : Monitor               = Monitor()
      let mm : MultiConditionMonitor = MultiConditionMonitor()

      testContended(rm)
      testContended(m)
      testContended(mm)

      testM()
      testMM1()
      testMM2()

      testSynchProdCons()
   } catch (e: Exception) {
      println(e)
      e.printStackTrace()
      return 1
   }

   asanGC()

   return 0
}
