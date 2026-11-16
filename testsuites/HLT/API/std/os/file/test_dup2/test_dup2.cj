/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_win) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_win) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args 
import std.unittest.*
import std.unittest.testmacro.*
import std.posix.*

@Test
class Test_dup2 {
    @TestCase
    func test_dup2_01(): Unit {
        var cre = creat("textcase.txt", S_IRWXU)
        @Assert(cre != -1, true)
        var fd = `open`("textcase.txt", O_RDWR)
        @Assert(fd != -1, true)
        var newFd: Int32 = 10

        var fd2 = dup2(fd, newFd)
        if (fd2 <= 0) {
            println("fd2失败: fd:${fd}, newFd: ${newFd}")
        }
        close(fd)
        println("fd 关闭成功")
        close(fd2)
        println("fd2 关闭成功")
        remove("textcase.txt")
        println("remove 移除成功")
        println(fd2)
        @Assert(fd2, 10)
    }

    @TestCase
    func test_dup2_02(): Unit {
        var fd2 = dup2(-1, 10)
        @Assert(fd2, -1)
    }
}
