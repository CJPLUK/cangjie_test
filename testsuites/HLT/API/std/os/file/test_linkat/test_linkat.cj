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
class Test_linkat {
    @TestCase
    func test_linkat_01(): Unit {
        let res = linkat(-100, "test.txt", -100, "testylinkat.txt", AT_SYMLINK_FOLLOW)
        @Assert(res, -1)
    }

    @TestCase
    func test_linkat_02(): Unit {
        var count = 0
        try {
            let res = linkat(-100, "test.txt", -100, "\0", AT_SYMLINK_FOLLOW)
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_linkat_03(): Unit {
        var count = 0
        try {
            let res = linkat(-100, "\0", -100, "test.txt", AT_SYMLINK_FOLLOW)
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_linkat_04(): Unit {
        var res: Int64
        var cre = creat("test.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = `open`("./", O_RDONLY)
        @Assert(fd != -1, true)
        let res1 = linkat(fd, "test.txt", fd, "testylinkat.txt", AT_SYMLINK_FOLLOW)
        @Assert(res1 != -1, true)
        let res2 = isReg("testylinkat.txt")
        if ((res1 == 0) && res2) {
            res = 0
        } else {
            res = 1
        }
        remove("test.txt")
        remove("testylinkat.txt")
        @Assert(res, 0)
    }
}
