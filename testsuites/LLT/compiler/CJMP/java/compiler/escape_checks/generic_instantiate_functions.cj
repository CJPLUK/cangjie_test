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
func genericFuncParam<T>(x: T): Unit {}

class C {
    static func foo<T>(x: T): Unit {}
    func bar<T, E>(x: E, y: T): Unit {}
}

func test() {
    let a = A()
    let b = B()
    
    genericFunc<A>()
    genericFunc<Option<A>>()
    genericFuncParam(a)
    genericFuncParam(Some(a))
    
    C.foo<B>(b)
    C().bar(Some(b), a)

    let args = JArray<A>(10)
}

// ASSERT: scan-6 sema_generic_parameter_of_java_type
// ASSERT: scan-2 '@Java A' type cannot be used on generic declaration 'genericFunc'
// ASSERT: scan-2 '@Java A' type cannot be used on generic declaration 'genericFuncParam'
// ASSERT: scan '@Java B' type cannot be used on generic declaration 'foo'
// ASSERT: scan '@Java B' type cannot be used on generic declaration 'bar'
// ASSERT: scan "Errors": 6
