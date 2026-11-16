// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-1 error: exported '@ObjC' declaration must inherit either foreign or exported '@ObjC' type
// ASSERT: scan 1 error generated, 1 error printed

import objc.lang.*

@ObjC
open foreign class M {
    init()
}

@ObjC
public class A <: M & C {
    public init() {}
}

public interface C {
    func f() { println("in cj f") }
}
