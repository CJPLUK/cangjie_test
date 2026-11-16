// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %mkdir java-gen
// (CJNATIVE and not Windows) RUN-EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>&1 | compare %f
// ASSERT: scan sema_java_mirror_method_arg_must_be_java_mirror
// ASSERT: scan 'Rune' is not java-compatible type

package cjworld.theworld

import java.lang.JObject

@Java["M"]
public open foreign class M {
    init()
    init(x: Int)
    init(x: Int, y: Int)
}

@Java["A"]
public class A <: M {
    init() {
        super(1)
        println("Hello from Cangjie!")
    }
    init(x: Int) {
        super(x, x)
    }

    func f(arg: Rune) {
        println(1)
    }
}
