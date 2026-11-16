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

main():Unit {
    @When[os == "iOS" && env == ""]
    var size:Int64=2
    @When[os != "iOS" || env != ""]
    var size:Int64=1
    let _thread = spawn { 
        return 0
    }
    sleep(Duration.second)
    let _thread_infos = ThreadSnapshot.dumpAllThreads()
    // 这里线程被回收无法获取
    @Assert(_thread_infos.size, size)
    @Assert(_thread.thread.state.toString(), "Terminated")
    @Assert(_thread.get(), 0)
}
