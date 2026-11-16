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

import std.unittest.*
import std.unittest.testmacro.*

class C1 {
    public static func foo() {
        while (true) {
            if (Thread.currentThread.hasPendingCancellation) {
                println("Thread.currentThread.hasPendingCancellation")
                return 0
            }
        }
        return 1
    }
}

let all_count = 20
var ready_count = 0
var running_count = 0
@When[os == "iOS" && env == ""]
var count:Int64=21
@When[os != "iOS" || env != ""]
var count:Int64=20
main() {
    let _ = Array<Future<Unit>>(all_count) { _ =>
        spawn { C1.foo() }
    }
    sleep(Duration.second * 3)
    let _thread_infos = ThreadSnapshot.dumpAllThreads()
    @Assert(_thread_infos.size, count + 1)
    for (_thread_info_id in 0..all_count) {
        let _thread_info = _thread_infos[_thread_info_id]
        match(_thread_info.state) {
            case ThreadState.Ready => ready_count++
            case ThreadState.Pending => @Assert(false)
            case ThreadState.Running => running_count++
            case _ => @Assert(false)
        }
        _thread_info.toString() |> println
        @Assert(_thread_info.toString().contains("ThreadSnapshot(id=${_thread_info.id}, name=, state=${_thread_info.state})"))
    }
    println("ready: ${ready_count}, running: ${running_count}")
    @Assert(ready_count + running_count, all_count)
}
