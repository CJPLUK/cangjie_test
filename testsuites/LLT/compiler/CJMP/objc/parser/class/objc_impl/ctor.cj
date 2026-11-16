// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import objc.lang.*

@ObjC
public open foreign class M {
    init(a: Bool)
    init()
}

@ObjC
class A <: M {
    A() {
        super()
    }

    init(b: Bool) { }
    init(i: Int64) { }
    init(o: ObjCId) { } // Uncomment after `ObjCId` implementation
    // init(oo: ?ObjCId) { } // Uncomment after `ObjCId` & Option implementation
    init(a: Int64, b: Bool) { }
    init(a: Int64, b: Bool, c: ?ObjCId, d: M, e: ?M) { }
}

@ObjC
class B <: M {
    B() {
        super()
    }
}
