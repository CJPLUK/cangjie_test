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
    // Checks that fields can be String
    protected let prots: String
    private let privs: String = ""
    internal var inters: String = privs
    var s = inters

    // Checks that constructors can accept String
    public init(s: String) {
        this.prots = s + "."
        this.s = s
    }



    public func useField() {
        let usage = prots + privs + inters + s
        println(usage)
        return usage
    }
}
