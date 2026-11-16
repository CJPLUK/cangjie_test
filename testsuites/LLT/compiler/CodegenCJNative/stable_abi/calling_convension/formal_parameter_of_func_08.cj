// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE) EXEC: %compiler %cmp_opt %f --save-temps . -j1 --apc=1 --output-type=staticlib
// (CJNATIVE) EXEC: %llvmDissembler %n.bc -o %n.ll
// (CJNATIVE) EXEC: %cat %n.ll 2>&1 | compare %f
// (CJNATIVE) ASSERT: scan define void @"_CN7default2SAIG_E3fooIG0_G1_Hl$withoutTI"(i8 addrspace(1)* noalias sret(i8) %0, i8* nocapture readonly %this, i64 %x, %TypeInfo* %ti.T1, %TypeInfo* %ti.T2, %TypeInfo* %outerTI)
// (CJNATIVE) ASSERT: scan define void @_CN7default2SAIG_E3fooIG0_G1_Hl(i8 addrspace(1)* noalias sret(i8) %0, i8 addrspace(1)* nocapture readonly %this, i64 %x, %TypeInfo* %ti.T1, %TypeInfo* %ti.T2, %TypeInfo* %outerTI)

struct SA<T> {
    SA(let x: T) {}
    func foo<T1, T2>(x: Int64): SA<T> {
        this
    }
}
