/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL:2
// DEPENDENCE: %n.c cfg.json
// EXEC: %sed %sed_opt "s!cangjieCFFI_path!%cstring_cjo!g" cfg.json
// EXEC: %clang %clang_opt %n.c -o %cffi_output
// EXEC-PIPE-1: %compiler %cmp_opt %ffic_opt -o %output 2>&1 | compare %f

foreign func testfunc(): CPointer<UInt8>

unsafe main(): Int64 {
    var ptr: CPointer<UInt8> = testfunc()
    var ptrtmp: CPointer<UInt8> = ptr + 1

    if ((ptr.read(0) == 0) && (ptr.read(1) == 2) && (ptr.read(2) == 255)) {
        ptr.write(-255)
    }

    return 0
}
// ASSERT: scan sema_exceed_num_value_range
