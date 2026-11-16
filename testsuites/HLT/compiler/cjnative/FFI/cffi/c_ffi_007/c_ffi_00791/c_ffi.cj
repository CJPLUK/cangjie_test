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


foreign func testfunc1(): CPointer<Float32>

foreign func testfunc2(): CPointer<Float64>

foreign func free(cp: CPointer<Float64>): Unit

unsafe main(): Int64 {
    var count = 0
    var ptr1: CPointer<Float32> = testfunc1()
    var ptr2: CPointer<Int32> = CPointer<Int32>(ptr1)
    var ptr3: CPointer<Float64> = testfunc2()
    var ptr4: CPointer<Int32> = CPointer<Int32>(ptr3)
    free(CPointer<Float64>(ptr1))
    free(ptr3)

    return 0
}
