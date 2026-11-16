// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.*

@Java
public open foreign class A {
    public init()
}

@Java
public open foreign class B {
    public init()
}

func genericFunc<T>(): Unit {}

open class X<T> {
    init() {}
    init(x: T) {}

    static func foo(x: T) {}
    static func bar<E>(x: E) {}
}

extend X<B> {}

class Y <: X<B> {}

func test() {
    let a = A()
    let b = B()
    
    let x = X<A>()
    let y = X(a)

    genericFunc<X<A>>()
    
    X.foo(Some(a))
    X<?B>.bar(a)
}

// ASSERT: scan-8 sema_generic_parameter_of_java_type
// ASSERT: scan-3 '@Java B' type cannot be used on generic declaration 'X'
// ASSERT: scan-2 '@Java A' type cannot be used on generic declaration 'init'
// ASSERT: scan-2 '@Java A' type cannot be used on generic declaration 'X'
// ASSERT: scan '@Java A' type cannot be used on generic declaration 'bar'
// ASSERT: scan "Errors": 8
