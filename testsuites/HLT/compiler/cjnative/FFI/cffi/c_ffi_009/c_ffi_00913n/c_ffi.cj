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
    public init(i8!: Int8, ui8!: UInt8) {
        this.i8 = i8
        this.ui8 = ui8
    }
}

foreign func testfunc(st: teststruct): Int8

unsafe main(): Int64 {
    let struct1 = teststruct(i8: 1, ui8: 1)
    func test(): () -> teststruct {
        match {
            case _ => {=> return struct1}
        }
    }

    testfunc(struct1)

    return 0
}
// ASSERT: scan sema_func_capture_var_not_ctype
