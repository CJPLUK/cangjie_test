// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

package javaapp.my

import java.lang.JObject
import std.unittest.assertEqual
import std.unittest.testmacro.Assert

@Java
open foreign class M {
    init()
}

@Java
class A <: M {
    A() {
        super()
    }
}

class CJClass {}

unsafe func testJObject(m: JObject) {
    @Assert((m as JObject).isSome())
    @Assert((m as M).isSome())
    @Assert((m as A).isSome())
    @Assert((m as CJClass).isSome())
}

unsafe func test(m: M) {
    @Assert((m as JObject).isSome())
    @Assert((m as M).isSome())
    @Assert((m as A).isSome())
    @Assert((m as CJClass).isSome())
}

unsafe func testCJClass(m: CJClass) {
    @Assert((m as JObject).isSome())
    @Assert((m as M).isSome())
    @Assert((m as A).isSome())
    @Assert((m as CJClass).isSome())
}
