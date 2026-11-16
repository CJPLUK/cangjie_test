// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import java.lang.JObject
import std.random.*

@Java
public class MyObject {
}

extend MyObject {
    private func foo(a: MyObject, b: Random): MyObject {
        return a
    }

    public func bar() {
    }

    public func boo(a: Random): Random {
        foo(this, a)
        a
    }
}
