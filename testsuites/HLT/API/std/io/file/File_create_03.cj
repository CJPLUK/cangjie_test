/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %cmp_opt -o %output %f %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.io.*
import std.fs.*

@Test
class TestFileCreation {
    @TestCase
    func testCase00(): Unit {
        let fileName = ""
        let e = @AssertThrows[IllegalArgumentException](File.create(fileName))
        @Assert(e.toString(), "IllegalArgumentException: Invalid argument 'path': cannot be empty.")
    }
}
