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
class Test_pwrite {
    @TestCase
    func test_pwrite_01(): Unit {
        var flag: Bool
        var cre = creat("textcase.txt", S_IRWXU)
        @Assert(cre != -1, true)
        var buf = unsafe { LibC.mallocCString("123456") }
        var fd = `open`("textcase.txt", O_RDWR)
        @Assert(fd != -1, true)
        var writeNum = unsafe { pwrite(fd, buf.getChars(), UIntNative(buf.size()), 0) }
        @Assert(writeNum != -1, true)
        var fd1 = `open`("textcase.txt", O_RDWR)
        @Assert(fd1 != -1, true)
        var buf1 = unsafe { LibC.mallocCString(" ") }
        var readNum = unsafe { read(fd1, buf1.getChars(), UIntNative(buf1.size())) }
        @Assert(readNum != -1, true)
        remove("textcase.txt")
        unsafe { LibC.free(buf) }
        unsafe { LibC.free(buf1) }
        @Assert(writeNum, 6)
        @Assert(readNum, 1)
    }

    @TestCase
    func test_pwrite_02(): Unit {
        var buf = unsafe { LibC.mallocCString("123456") }
        var writeNum = unsafe { pwrite(-1, buf.getChars(), UIntNative(buf.size()), 0) }
        @Assert(writeNum, -1)
        unsafe { LibC.free(buf) }
    }
}
