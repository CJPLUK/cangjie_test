// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import java.lang.JObject

@Java
open foreign class M {
    init(a: Bool)
    init()
}

@Java
class A <: M {
    A() {
        super()
    }

    init(b: Bool) { }
    init(i: Int64) { }
    init(o: JObject) { }
    init(oo: ?JObject) { }
    init(a: Int64, b: Bool) { }
    init(a: Int64, b: Bool, c: ?JObject, d: M, e: ?M) { }
}

@Java
class B <: M {
    B() {
        super()
    }
}
