/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %use_ast %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.unittest.*
import std.unittest.testmacro.*

main():Unit {
    @When[os == "iOS" && env == ""]
    var size:Int64=3
    @When[os != "iOS" || env != ""]
    var size:Int64=2
    let _thread = spawn {
        while (true) {
            if (Thread.currentThread.hasPendingCancellation) {
                return 0
            }
        }
        return 1
    }
    let _thread_infos = ThreadSnapshot.dumpAllThreads()
    @Assert(_thread_infos.size, size)
    func findThread(id: Int64, infos: Array<ThreadSnapshot>): ThreadSnapshot {
        for (info in infos) {
            if (info.id == id) {
                return info
            }
        }
        throw IllegalArgumentException("Thread id ${id} not found in thread snapshots")
    }
    let _thread_info = findThread(_thread.thread.id, _thread_infos)
    @Assert(_thread_info.id is Int64)
    @Assert(_thread_info.name, "")
    match(_thread_info.state) {
        case ThreadState.Ready => println("Ready")
        case ThreadState.Running => println("Running")
        case _ => @Assert(false)
    }
    _thread_info.toString() |> println
    @Assert(_thread_info.toString().contains("ThreadSnapshot(id=${_thread_info.id}, name=, state=${_thread_info.state})"))
    @Assert(_thread_info.toString().contains("stack trace"))

    _thread.cancel()
    sleep(Duration.second)
    @Assert(_thread.get(), 0)
}
