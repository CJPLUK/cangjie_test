/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// (!target_ios & !target_win) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_ios & !target_win) RUN-EXEC: %run %run_opt %output %run_args %run_utest_opt
import std.unittest.*
import std.unittest.testmacro.*
import std.posix.*

@Test
class Test_lseek {
    @TestCase
    func test_lseek_01(): Unit {
        var fd = `open`("test_lseek.cj", O_RDWR)
        @Assert(fd != -1, true)
        var len = lseek(fd, 0, SEEK_END)
        @Assert(len != -1, true)
        close(fd)
        @Assert(len, 1526)
    }

    @TestCase
    func test_lseek_02(): Unit {
        var fd = `open`("test_lseek.cj", O_RDWR)
        @Assert(fd != -1, true)
        var len = lseek(fd, 0, SEEK_CUR)
        @Assert(len != -1, true)
        close(fd)
        @Assert(len, 0)
    }

    @TestCase
    func test_lseek_03(): Unit {
        var fd = `open`("test_lseek.cj", O_RDWR)
        @Assert(fd != -1, true)
        var len = lseek(fd, 0, SEEK_SET)
        @Assert(len != -1, true)
        close(fd)
        @Assert(len, 0)
    }

    @TestCase
    func test_lseek_04(): Unit {
        var fd = `open`("test_lseek.cj", O_RDWR)
        @Assert(fd != -1, true)
        var len = lseek(fd, -1, SEEK_SET)
        close(fd)
        @Assert(len, -1)
    }
}
