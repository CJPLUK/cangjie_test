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
class Test_fchown {
    @TestCase
    func test_fchown_01(): Unit {
        let res = fchown(32, UInt32(32), UInt32(32))
        @Assert(res, -1)
    }
}
