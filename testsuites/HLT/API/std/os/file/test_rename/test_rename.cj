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
class Test_rename {
    @TestCase
    func test_rename_01(): Unit {
        var cre = creat("oldname.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let res = rename(
            "oldname.txt",
            "newname.txt"
        )
        @Assert(cre != -1, true)
        var res1 = isReg("newname.txt")
        var res2 = isReg("oldname.txt")
        var rem = remove("newname.txt")
        @Assert(rem != -1, true)
        @Assert(res, 0)
        @Assert(res1, true)
        @Assert(res2, false)
    }

    @TestCase
    func test_rename_02(): Unit {
        let res = rename("oldname.txt", "")
        @Assert(res, -1)
    }

    @TestCase
    func test_rename_03(): Unit {
        let res = rename(
            "",
            "oldname.txt"
        )
        @Assert(res, -1)
    }

    @TestCase
    func test_rename_04(): Unit {
        var count = 0
        try {
            let res = rename(
                "\0",
                "oldname.txt"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_rename_05(): Unit {
        var count = 0
        try {
            let res = rename("oldname.txt", "\0")
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }
}
