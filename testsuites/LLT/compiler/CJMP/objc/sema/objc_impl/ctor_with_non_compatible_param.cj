// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f %diag_json -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-8 sema_objc_interop_ctor_param_must_be_objc_compatible

// 1 diag message per parameter

import objc.lang.*

@ObjC
public open foreign class M {
    init()
}

public class PureCangjieClass {}

public interface PureCangjieInterface {}

public struct PureCangjieStruct {}

public enum PureCangjieEnum { A | B }

@ObjC
public class A <: M {
    @ForeignName["initWithPureCangjieClass:"]
    public init(c: PureCangjieClass) { }

    @ForeignName["initWithPureCangjieInterface:"]
    public init(i: PureCangjieInterface) { }
    
    @ForeignName["initWithPureCangjieStruct:"]
    public init(s: PureCangjieStruct) { }
    
    @ForeignName["initWithPureCangjieEnum:"]
    public init(e: PureCangjieEnum) { }
    
    @ForeignName["initWithPureCangjieWithC:andI:andS:andE:andMirror:"]
    public init(
        c: PureCangjieClass, 
        i: PureCangjieInterface, 
        s: PureCangjieStruct, 
        e: PureCangjieEnum, 
        mirror: M
    ) { }
}
