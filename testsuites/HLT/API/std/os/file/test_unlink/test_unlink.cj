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
class Test_unlink {
    @TestCase
    func test_unlink_01(): Unit {
        var res: Int64
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        var link = link(
            "file.txt",
            "linkfile.txt"
        )
        @Assert(link != -1 , true)
        let res1 = isReg("linkfile.txt")
        let res2 = unlink("linkfile.txt")
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
    func test_unlink_02(): Unit {
        var res: Int64
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        var link = symlink(
            "file.txt",
            "symlinkfile.txt"
        )
        @Assert(link != -1 , true)
        let res1 = isReg("symlinkfile.txt")
        let res2 = unlink("symlinkfile.txt")
        @Assert(res2 != -1 , true)
        let res3 = isReg("symlinkfile.txt")
        if (!res1 && res2 == 0 && !res3) {
            res = 0
        } else {
            res = 1
        }
        remove("file.txt")
        @Assert(res, 0)
    }

    @TestCase
    func test_unlink_03(): Unit {
        var count = 0
        try {
            let res = unlink("\0")
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_unlink_04(): Unit {
        let res = unlink("linkfile.txt")
        @Assert(res, -1)
    }

    @TestCase
    func test_unlink_05(): Unit {
        let res = unlink("/")
        @Assert(res, -1)
    }
}
