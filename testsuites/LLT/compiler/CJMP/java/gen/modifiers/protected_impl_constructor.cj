// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L. --output-javagen-dir=src/java/impl
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./src/java/impl/A.java | compare %f

// ASSERT: scan protected A(int i)
// ASSERT: scan initCJObjecti(int i);

// This test checks that protected constructor of @Java is exported to java.

package cjworld.theworld

import java.lang.*

@Java["A"]
public class A {
    public init() {}
    protected init(i: Int32) {}
    public func foo(): Unit {}
}
