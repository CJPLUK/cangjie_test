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


foreign func testfunc(): CPointer<Bool>

unsafe main():Int64 {
    var ptr: CPointer<Bool> = unsafe{testfunc()}
    unsafe { unsafe { unsafe { unsafe { if (!ptr.isNotNull()) { return 1 } } } } }

    unsafe { unsafe { unsafe { if (ptr.isNull()) { return 2 } } } }

    unsafe { if (!ptr.read(0) || ptr.read(1)) { return 3 } }

    unsafe { => print("Hello") } 

    print("CPointer Type Bool\n")
    return 0
}
// ASSERT: scan parse_expected_expr_or_decl_in
