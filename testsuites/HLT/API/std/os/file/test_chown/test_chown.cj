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
class Test_chown {
    @TestCase
    func test_chown_01(): Unit {
        let res = chown("oscfg.cfg", UInt32(0), UInt32(0))
        @Assert(res, -1)
    }

    @TestCase
    func test_chown_02(): Unit {
        var count = 0
        try {
            chown("\0", UInt32(0), UInt32(0))
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }
}
