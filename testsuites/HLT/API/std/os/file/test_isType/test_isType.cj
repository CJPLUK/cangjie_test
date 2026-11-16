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
class Test_isType {
    @TestCase
    func test_isType_01(): Unit {
        var cre = creat("textcase.txt", S_IRWXU)
        @Assert(cre != -1, true)
        var res = isType("textcase.txt", S_IFREG)
        remove("textcase.txt")
        @Assert(res, true)
    }

    @TestCase
    func test_isType_02(): Unit {
        var res = isType("/", S_IFREG)
        @Assert(res, false)
    }

    @TestCase
    func test_isType_03(): Unit {
        var res = isType("\0", S_IFREG)
        @Assert(res, false)
    }
}
