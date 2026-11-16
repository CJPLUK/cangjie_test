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
class Test_pread {
    @TestCase
    func test_pread_01(): Unit {
        var cre = creat("textcase.txt", S_IRWXU)
        @Assert(cre != -1, true)
        var buf = unsafe { LibC.mallocCString(" ") }
        var fd = `open`("textcase.txt", O_RDWR)
        @Assert(fd != -1, true)
        var readNum = unsafe { pread(fd, buf.getChars(), UIntNative(1024), 0) }
        @Assert(readNum != -1, true)
        remove("textcase.txt")
        @Assert(readNum, 0)
        unsafe { LibC.free(buf) }
    }

    @TestCase
    func test_pread_02(): Unit {
        var buf = unsafe { LibC.mallocCString(" ") }
        var readNum = unsafe { pread(-1, buf.getChars(), UIntNative(1024), 0) }
        @Assert(readNum, -1)
        unsafe { LibC.free(buf) }
    }
}
