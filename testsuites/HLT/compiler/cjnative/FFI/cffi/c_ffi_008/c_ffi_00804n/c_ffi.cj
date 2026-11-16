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



unsafe main():Int64 {
    foreign func testfunc(): CPointer<Bool> 

    var ptr: CPointer<Bool> = testfunc()

    if (!ptr.isNotNull()) {
        return 1
    }

    if (ptr.isNull()) {
        return 2
    }

    if (!ptr.read(0) || ptr.read(1)) {
        return 3
    }

    print("CPointer Type Bool\n")
    return 0
}
// ASSERT: scan parse_illegal_modifier_in_scope
