// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

import objc.lang.*

@ObjC
public open foreign class M {
    @ForeignName["initWithA:"]
    init(a: Bool)
}

@ObjC
public class A <: M {
    @ForeignName["initWithB:"]
    public init(b: Bool) {
        super(b)
    }

    @ForeignName["initWithA:andB:"]
    public init(a: M, b: Bool) {
        this(b)
    }

    @ForeignName["initWithM:"]
    public init(a: M) {
        this(a, true)
    }

    @ForeignName["initWithA:"]
    public init(a: A) {
        this(a, true)
    }

    @ForeignName["initWithA:andM:"]
    public init(a: A, m: M) {
        this(a)
    }
}
