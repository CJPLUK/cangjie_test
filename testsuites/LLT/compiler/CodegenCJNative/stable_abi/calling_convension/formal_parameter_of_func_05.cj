// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE) EXEC: %compiler %cmp_opt %f --save-temps . -j1 --apc=1 --output-type=staticlib
// (CJNATIVE) EXEC: %llvmDissembler %n.bc -o %n.ll
// (CJNATIVE) EXEC: %cat %n.ll 2>&1 | compare %f
// (CJNATIVE) ASSERT: scan define i64 @"_CN7default2SAIG_E3fooHb$withoutTI"(i8* nocapture readonly %this, i1 %x, %TypeInfo* %outerTI)
// (CJNATIVE) ASSERT: scan define i64 @_CN7default2SAIG_E3fooHb(i8 addrspace(1)* nocapture readonly %this, i1 %x, %TypeInfo* %outerTI)

struct SA<T> {
    SA(let x: T) {}
    func foo(x: Bool) {
        1
    }
}

func test<T>(para: T) {
    let sa1 = SA<Int64>(50)
    sa1.foo(true)
    let sa2 = SA<T>(para)
    sa2.foo(true)
}
