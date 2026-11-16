/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: ../util/run.sh ../util/test.c ../util/cstr2int.c
// (native_compilation & !target_win) EXEC: %clang %clang_opt cstr2int.c -o %cffi_output
// (native_compilation & !target_win) EXEC: %compiler %cmp_opt %ffic_opt -o %output
// (native_compilation & !target_win) RUN-EXEC-PIPE: %target_shell run.sh "%run %run_opt %output %run_args" | compare %f
// (native_compilation & !target_win) ASSERT: scan pass1
// (native_compilation & !target_win) ASSERT: scan pass3

import std.posix.*

foreign func printf(fmt: CString): Int32

foreign func cstr2int(cstr: CString): Int32

unsafe func readtxt(): Int32 {
    var arr: Array<Rune> = Array<Rune>(100, {i => r'\0'})
    var str: String = String(arr)
    var buf = LibC.mallocCString(str)
    var fd = `open`("test.txt", O_RDWR)
    var readNum = read(fd, buf.getChars(), UIntNative(1024))
    close(fd)
    var mypid: Int32 = cstr2int(buf)
    LibC.free(buf)
    return mypid
}

unsafe main() {
    var pid: Int32 = readtxt()
    var result1 = kill(pid, SIGSTOP)

    if (result1 == 0) {
        print(pid.toString())
    }
    return 0
}
