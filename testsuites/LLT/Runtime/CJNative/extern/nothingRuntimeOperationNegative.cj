// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-7 can not instantiate 'Generics-T' by 'Nothing' for it has unimplemented static member
// ASSERT: scan-1 7 errors generated
// ASSERT: scan-not Internal Compiler Error

// Nothing satisfies the constraint of Extern<T>, but it has no static functions for the dynamic operations on
// Extern<Nothing>. No value of this type can be created, see nothingRuntimeConversionNegative.cj, but a function may
// still declare a parameter of this type.

func memberRead(e: Extern<Nothing>): Unit {
    let _ = e.field
}

func memberWrite(e: Extern<Nothing>): Unit {
    e.field = 1
}

func memberCompound(e: Extern<Nothing>): Unit {
    e.field += 1
}

func indexRead(e: Extern<Nothing>): Unit {
    let _ = e[0]
}

func indexWrite(e: Extern<Nothing>): Unit {
    e[0] = 1
}

func indexCompound(e: Extern<Nothing>): Unit {
    e[0] += 1
}

func call(e: Extern<Nothing>): Unit {
    let _ = e(1)
}

main() {
    0
}
