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

public func foo() {
    while (true) {
        if (Thread.currentThread.hasPendingCancellation) {
            println("Thread.currentThread.hasPendingCancellation")
            return 0
        }
    }
    return 1
}

// check threadstate changes
@When[os == "iOS" && env == ""]
var size:Int64=3
@When[os != "iOS" || env != ""]
var size:Int64=2
main():Unit {
    let _thread = spawn { 
        sleep(Duration.second * 3)
        foo()
    }
    var _thread_infos = ThreadSnapshot.dumpAllThreads()

    @Assert(_thread_infos.size, size)
    func findThread(id: Int64, infos: Array<ThreadSnapshot>): ThreadSnapshot {
        for (info in infos) {
            if (info.id == id) {
                return info
            }
        }
        throw IllegalArgumentException("Thread id ${id} not found in thread snapshots")
    }
    var _thread_info = findThread(_thread.thread.id, _thread_infos)

    // 轮询等待子线程进入 Pending 状态（替代固定 sleep(1)）
    var _retry = 0
    while (_retry < 100) {
        _thread_infos = ThreadSnapshot.dumpAllThreads()
        @Assert(_thread_infos.size, size)
        _thread_info = findThread(_thread.thread.id, _thread_infos)
        if (match(_thread_info.state) { case ThreadState.Pending => true; case _ => false }) {
            break
        }
        sleep(Duration.millisecond * 100)
        _retry++
    }
    match(_thread_info.state) {
        case ThreadState.Pending => println("Pending")
        case _ => @Assert(false)
    }
    _thread_info.toString() |> println
    @Assert(_thread_info.toString().contains("ThreadSnapshot(id=${_thread_info.id}, name=, state=Pending)"))

    // 轮询等待子线程转出 Pending（替代固定 sleep(3)）
    _retry = 0
    while (_retry < 100) {
        _thread_infos = ThreadSnapshot.dumpAllThreads()
        _thread_info = findThread(_thread.thread.id, _thread_infos)
        if (match(_thread_info.state) { case ThreadState.Pending => false; case _ => true }) {
            break
        }
        sleep(Duration.millisecond * 100)
        _retry++
    }
    _thread_infos = ThreadSnapshot.dumpAllThreads()
    @Assert(_thread_infos.size, size)
    _thread_info = findThread(_thread.thread.id, _thread_infos)
    match(_thread_info.state) {
        case ThreadState.Running => println("Running")
        case ThreadState.Ready => println("Ready")
        case _ => @Assert(false)
    }
    _thread_info.toString() |> println
    @Assert(_thread_info.toString().contains("ThreadSnapshot(id=${_thread_info.id}, name=, state=${_thread_info.state})"))

    _thread.cancel()
    sleep(Duration.second)
    _thread_infos = ThreadSnapshot.dumpAllThreads()
    @Assert(_thread_infos.size, size-1)
    @Assert(_thread.thread.state.toString(), "Terminated")
    @Assert(_thread.get(), 0)
}
