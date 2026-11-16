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
class Test_link {
    @TestCase
    func test_link_01(): Unit {
        var res: Int64
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let res1 = link(
            "file.txt",
            "testfile.txt"
        )
        let res2 = isReg("testfile.txt")
        if ((res1 == 0) && res2) {
            res = 0
        } else {
            res = 1
        }
        remove("file.txt")
        remove("testfile.txt")
        @Assert(res, 0)
    }

    @TestCase
    func test_link_02(): Unit {
        var count = 0
        try {
            let res = link(
                "\0",
                "/testfile.txt"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_link_03(): Unit {
        var count = 0
        try {
            let res = link(
                "/testfile.txt",
                "\0"
            )
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }
}
