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
class Test_renameat {
    @TestCase
    func test_renameat_01(): Unit {
        var cre = creat("oldname.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = `open`("./", O_RDONLY)
        @Assert(fd != -1, true)
        let res = renameat(
            fd,
            "oldname.txt",
            fd,
            "newname.txt"
        )
        @Assert(res != -1, true)
        var res1 = isReg("newname.txt")
        var res2 = isReg("oldname.txt")
        remove("newname.txt")
        @Assert(res, 0)
        @Assert(res1, true)
        @Assert(res2, false)
    }

    @TestCase
    func test_renameat_02(): Unit {
        var cre = creat("oldname.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = `open`("./", O_RDWR)
        @Assert(fd != -1, false)
        let res = renameat(
            fd,
            "/oldname.txt",
            fd,
            ""
        )
        var rem = remove("oldname.txt")
        @Assert(rem != -1, true)
        @Assert(res, -1)
    }

    @TestCase
    func test_renameat_03(): Unit {
        var cre = creat("oldname.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = `open`("./", O_RDWR)
        @Assert(fd != -1, false)
        let res = renameat(
            fd,
            "",
            fd,
            "/newname.txt"
        )
        var rem = remove("oldname.txt")
        @Assert(rem != -1, true)
        @Assert(res, -1)
    }

    @TestCase
    func test_renameat_04(): Unit {
        var count = 0
        try {
            let fd = `open`(
                "/test/workspace/std_os/cangjie/tests/HLT/testsuites/API/OS/file/test_renameat",
                O_RDWR
            )
            let res = renameat(
                fd,
                "\0",
                fd,
                "/newname.txt"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_renameat_05(): Unit {
        var count = 0
        try {
            let fd = `open`(
                "/test/workspace/std_os/cangjie/tests/HLT/testsuites/API/OS/file/test_renameat",
                O_RDWR
            )
            let res = renameat(
                fd,
                "/oldname.txt",
                fd,
                "\0"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }
}
