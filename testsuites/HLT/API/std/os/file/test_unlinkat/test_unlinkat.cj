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
class Test_unlinkat {
    @TestCase
    func test_unlinkat_01(): Unit {
        var res: Int64
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        var link = symlink(
            "file.txt",
            "symlinkfile.txt"
        )
        @Assert(link != -1 , true)
        let res1 = isReg("symlinkfile.txt")
        var fd = `open`(
            "./",
            O_RDONLY
        )
        @Assert(fd != -1 , true)
        var res2 = unlinkat(fd, "symlinkfile.txt", 0)
        @Assert(res2 != -1 , true)
        let res3 = isReg("symlinkfile.txt")
        if (!res1 && res2 == 0 && !res3) {
            res = 0
        } else {
            res = 1
        }
        var rem = remove("file.txt")
        @Assert(rem != -1 , true)
        @Assert(res, 0)
    }

    @TestCase
    func test_unlinkat_02(): Unit {
        var res: Int64
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        var link = link(
            "file.txt",
            "linkfile.txt"
        )
        @Assert(link != -1 , true)
        let res1 = isReg("linkfile.txt")
        var fd = `open`(
            "./",
            O_RDONLY
        )
        @Assert(fd != -1 , true)
        var res2 = unlinkat(fd, "linkfile.txt", 0)
        @Assert(res2 != -1 , true)
        let res3 = isReg("linkfile.txt")
        if (res1 && res2 == 0 && !res3) {
            res = 0
        } else {
            res = 1
        }
        var rem = remove("file.txt")
        @Assert(rem != -1 , true)
        @Assert(res, 0)
    }

    @TestCase
    func test_unlinkat_03(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        var fd = `open`(
            "./",
            O_RDONLY
        )
        @Assert(fd != -1 , true)
        var res = unlinkat(fd, "linkfile.txt", 0)
        var rem = remove("file.txt")
        @Assert(rem != -1 , true)
        @Assert(res, -1)
    }

    @TestCase
    func test_unlinkat_04(): Unit {
        var count = 0
        try {
            var fd = `open`(
                "./",
                O_RDONLY
            )
            var res = unlinkat(fd, "\0", 0)
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }
}
