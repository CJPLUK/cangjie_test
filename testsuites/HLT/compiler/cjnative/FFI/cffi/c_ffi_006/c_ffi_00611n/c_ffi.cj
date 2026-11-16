/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL:2
// DEPENDENCE: ../%n.c cfg.json
// EXEC: %sed %sed_opt "s!cangjieCFFI_path!%cstring_cjo!g" cfg.json
// EXEC: %clang %clang_opt %n.c -o %cffi_output
// EXEC-PIPE-1: %compiler %cmp_opt %ffic_opt -o %output 2>&1 | compare %f

foreign func printf(fmt: CString): Int32

foreign func testfunc(fmt: CString): CString

main(): Int64 {
    var a: CString = unsafe { LibC.mallocCString("Hello ") }
    var b: CString = unsafe { LibC.mallocCString("World\n") }
    var str: CString
    unsafe { str = testfunc(a) }
    var substr1 = str.subCString(-1)
    unsafe { printf(str) }
    unsafe { printf(substr1) }
    unsafe { LibC.free(str) }
    str = CString(CPointer<UInt8>())
    unsafe { LibC.free(substr1) }
    str = CString(CPointer<UInt8>())
    if (substr1.isEmpty()) {
        print("PASS\n")
    } else {
        print("ERROR\n")
    }
    unsafe { LibC.free(a) }
    unsafe { LibC.free(b) }
    return 0
}
// ASSERT: scan sema_exceed_num_value_range
