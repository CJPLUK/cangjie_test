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
    init()

    @ForeignName["MirrorOptionRet"]
    public func MirrorOptionRet(): Option<M>

    @ForeignName["ImplOptionRet"]
    public func ImplOptionRet(): Option<A>

    @ForeignName["MirrorOptionArg"]
    public func MirrorOptionArg(x: Option<M>): Unit

    @ForeignName["ImplOptionArg"]
    public func NonCompatibleOptionTypeArg(x: Option<A>): Unit
}

@ObjC
public class A <: M {
    init() {}

    @ForeignName["ImplMirrorOptionRet"]
    public func ImplMirrorOptionRet(): Option<M> { None }

    @ForeignName["ImplImplOptionRet"]
    public func ImplImplOptionRet(): Option<A> { None }

    @ForeignName["ImplMirrorOptionArg"]
    public func ImplMirrorOptionArg(x: Option<M>): Unit {}

    @ForeignName["ImplImplOptionArg"]
    public func ImplNonCompatibleOptionTypeArg(x: Option<A>): Unit {}
}
