// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.*

@Java["test1"]
public foreign interface test1 {
    @JavaHasDefault func f1(): Unit
    static func f2(): Unit
}

@Java["test2"]
public open foreign class test2 <: test1 {
    @ForeignName["f1"] public open func f1(a: Int32): Unit
    @ForeignName["f2"] public static func f2(a: Int32): Unit
}

// ASSERT: scan-not error
