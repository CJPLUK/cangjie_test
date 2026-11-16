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
// ERRCHECK: %compiler %cmp_opt %ffic_opt -o %output

foreign func testfunc(cb: CFunc<(Int8, Int8) -> Int8>): Int8

func add_i8(a: Int8, b: Int8): Int8 {
    return a + b
}

unsafe main(): Int64 {
    if (testfunc(add_i8) == -128) {
        print("pass\n")
    } else {
        print("fail\n")
    }
    return 0
}
// ASSERT: scan sema_no_match_function_declaration_for_ref
