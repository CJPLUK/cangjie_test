/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL:2
// DEPENDENCE: %n.c
// EXEC: %clang %clang_opt %n.c -o %cffi_output

// EXEC: %compiler %cmp_opt %ffic_opt -o %output

// RUN-EXEC: %run %run_opt %output %run_args


foreign func testfunc(): CString

unsafe main(): Int64 {
    var count = 0
    var cstr1 = testfunc()
    var cptr = cstr1.getChars()
    if (cptr.read(0) == 72 && cptr.read(1) == 101 && cptr.read(2) == 108 && cptr.read(7) == 111) {
        count += 1
    }
    cptr.write(7, UInt8(112))
    cstr1 = CString(cptr)
    var cStr2 = unsafe { LibC.mallocCString("Hello Wprld\n") }
    if (cstr1.equals(cStr2)) {
        count += 1
    }

    unsafe { LibC.free(cstr1) }
    unsafe { LibC.free(cStr2) }

    if (count == 2) {
        return 0
    } else {
        return 1
    }
}
