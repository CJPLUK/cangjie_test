// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %dump-ast %cmp_opt %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f

import java.lang.JObject

@Java["my.java.Fooer"]
class M1 <: JObject {
    @ForeignName["fooJava"]
    public func foo(): Unit {}
}

// ASSERT: scan-not error
// ASSERT: scan Java_my_java_Fooer_fooJava
