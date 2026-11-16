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

@C
struct teststruct {
    public var i8: Int8
    public var ui8: UInt8
}

foreign func testfunc(st: teststruct): Int8

enum testenum {
    | Var1(Int8)
    | Var2(teststruct)
    | Var3(UInt8)
}

unsafe main(): Int64 {
    var struct1 = teststruct(i8: 111, ui8: 111)
    testfunc(struct1)

    return 0
}
// ASSERT: scan sema_class_uninitialized_field
// ASSERT: scan sema_enum_pattern_func_param_cty_error
// ASSERT: scan sema_wrong_number_of_arguments
