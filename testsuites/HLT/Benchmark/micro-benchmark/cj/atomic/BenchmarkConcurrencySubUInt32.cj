/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping --no-sub-pkg %cmp_utest_opt -Woff=all %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run %run_opt %output %run_utest_opt %run_args --bench --no-color

import std.sync.*
import std.time.*
import std.runtime.*

var reps = 1000

class WaitGroup {
    var m: Monitor = Monitor()
    private var cnt: Int64

    public init(cnt: Int64) {
        this.cnt = cnt
    }

    public func add(n: Int64) {
        m.lock()
        cnt += n
        if (cnt == 0) {
            m.notifyAll()
        } else if (cnt < 0) {
            throw Exception("negative WaitGroup counter")
        }
        m.unlock()
    }

    public func done() {
        this.add(-1)
    }

    public func wait() {
        m.lock()
        while (cnt > 0) {
            m.wait()
        }
        m.unlock()
    }
}

@Test
@Configure[minDuration: Duration.second * 3]
@Configure[warmup: Duration.second]
@Measure[TimeNow(Nanos)]
public class Test_ConcurrencySubUInt32 {
    @Bench
    func BenchmarkConcurrencySubUInt32(): Unit {
        let test = AtomicUInt32(0)
        let wg = WaitGroup(0)
        wg.add(reps)

        for (i in 0..reps) {
            let thread: Future<Unit> = spawn {
                for (j in 0..10000) {
                    blackBox(test.fetchSub(1))
                }
                wg.done()
            }
        }
        wg.wait()
    }
}