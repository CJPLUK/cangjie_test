// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan error: unexpected annotation '@ObjCOptional' on prop
// ASSERT: scan error: unexpected annotation '@ObjCOptional' on class
// ASSERT: scan error: '@ObjCOptional' member function must be declared within '@ObjC' foreign interface
// ASSERT: scan 3 errors generated, 3 errors printed

import objc.lang.*

@ObjC
public foreign interface I {
    @ObjCOptional // unexpected annotation '@ObjCOptional' on prop
    prop a: UInt64
}

@ObjCOptional // unexpected annotation '@ObjCOptional' on class
public class M {
    init() {}
}

@ObjC
public foreign class N {
    init()

    @ObjCOptional // @ObjCOptional method must be declared within '@Obj' foreign interface
    func bar(): Unit
}
