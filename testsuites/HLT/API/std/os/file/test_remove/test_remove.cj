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
class Test_remove {
    @TestCase
    func test_remove_01(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let res1 = isReg("file.txt")
        let res2 = remove("file.txt")
        @Assert(res2 != -1, true)
        let res3 = isReg("file.txt")
        @Assert(res1, true)
        @Assert(res2, 0)
        @Assert(res3, false)
    }

    @TestCase
    func test_remove_02(): Unit {
        let res = remove("/#$")
        @Assert(res, -1)
    }

    @TestCase
    func test_remove_03(): Unit {
        var count = 0
        try {
            let res = remove("\0")
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }
}
