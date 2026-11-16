 /*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// EXEC: %compiler %cmp_opt %use_ast %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.random.*
import std.unittest.*
import std.unittest.testmacro.*

@When[os == "iOS" && env == ""]
var count:Int64=21
@When[os != "iOS" || env != ""]
var count:Int64=20
let all_count = 20
var ready_count = 0
var running_count = 0
var pending_count = 0
var terminated_count = 0
let random = Random()

class C1 {
    public static func foo() {
        spawn {
            sleep(Duration.second * 10)
        }
        while (true) {
            if (Thread.currentThread.hasPendingCancellation) {
                println("Thread.currentThread.hasPendingCancellation")
                terminated_count++
                return 0
            }
        }
        return 1
    }
}

main() {
    let _threads = Array<Future<Unit>>(all_count) { _ =>
        if (random.nextBool()) {
            spawn { C1.foo() }
        } else {
            spawn { sleep(Duration.second * 10) }
        }
    }
    sleep(Duration.second * 3)
    for (_thread in _threads) {
        _thread.cancel()
    }
    sleep(Duration.second * 3)
    let _thread_infos = ThreadSnapshot.dumpAllThreads()
    for (_thread_info_id in 0.._thread_infos.size) {
        let _thread_info = _thread_infos[_thread_info_id]
        match(_thread_info.state) {
            case ThreadState.Ready => ready_count++
            case ThreadState.Pending => pending_count++
            case ThreadState.Running => running_count++
            case _ => @Assert(false)
        }
        _thread_info.toString() |> println
        @Assert(_thread_info.toString().contains("ThreadSnapshot(id=${_thread_info.id}, name=, state=${_thread_info.state})"))
    }
    println("ready: ${ready_count}, running: ${running_count}, pending: ${pending_count}, terminated: ${terminated_count}")
    @Assert(ready_count + running_count + pending_count, count + 1)
}
