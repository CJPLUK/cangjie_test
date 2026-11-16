// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import java.lang.*

@Java
class M {
    let s: String

    // Checks that constructors can accept String
    public init(s: String) {
        this.s = s
    }

    private init(_: Bool, s: String) {
        this.s = s
    }

    init(s1: String, _: String) {
        s = s1
    }

    internal init(_: String, _: String, s3: String) {
        s = s3
    }

    // Proxying call
    public init(s1: String, s2: String, s3: String, s4: String) {
        // TODO: Uncomment after `this()` constructor call support
        // this(s1, s2, s3 + s4)
        s = s1 + s2 + s3 + s4
    }
}
