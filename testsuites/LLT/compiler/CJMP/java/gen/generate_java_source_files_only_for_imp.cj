// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %mkdir java-gen
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) EXEC: %ls ./java-gen/ | compare %f
// (CJNATIVE and not Windows) ASSERT: regex-not M.java
// (CJNATIVE and not Windows) ASSERT: regex A.java

package cjworld.theworld

import java.lang.JObject

@Java["M"]
public open foreign class M {
    init()
}

@Java["A"]
public class A <: M {
    init() {
        super()
        println("Hello from Cangjie!")
    }
}
