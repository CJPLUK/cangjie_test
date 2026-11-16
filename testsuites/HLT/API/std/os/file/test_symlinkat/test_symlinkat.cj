/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_win) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_win) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args 
import std.unittest.*
import std.unittest.testmacro.*
import std.posix.*

@Test
class Test_symlinkat {
    @TestCase
    func test_symlinkat_01(): Unit {
        var res: Int64
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        let fd = `open`("./", O_RDONLY)
        @Assert(fd != -1 , true)
        let res1 = symlinkat(
            "file.txt",
            fd,
            "filelink.txt"
        )
        @Assert(res1 != -1 , true)
        let res2 = isReg("filelink.txt")
        if ((res1 == 0) && !res2) {
            res = 0
        } else {
            res = 1
        }
        var rem = remove("filelink.txt")
        @Assert(rem != -1, true)
        var rem1 = remove("file.txt")
        @Assert(rem1 != -1, true)
        @Assert(res, 0)
    }

    @TestCase
    func test_symlinkat_02(): Unit {
        var count = 0
        try {
            let res = symlinkat(
                "\0",
                0,
                "/filelink.txt"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_symlinkat_03(): Unit {
        var count = 0
        try {
            let res = symlinkat(
                "/filelink.txt",
                0,
                "\0"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_symlinkat_04(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        let fd = `open`("./", O_RDONLY)
        @Assert(fd != -1 , true)
        let res = symlinkat(
            "file.txt",
            fd,
            "/"
        )
        var rem = remove("file.txt")
        @Assert(rem != -1 , true)
        @Assert(res, -1)
    }

    @TestCase
    func test_symlinkat_05(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1 , true)
        let fd = `open`("./", O_RDONLY)
        @Assert(fd != -1 , true)
        let res = symlinkat(
            "/",
            fd,
            "file.txt"
        )
        var rem = remove("file.txt")
        @Assert(rem != -1 , true)
        @Assert(res, -1)
    }
}
