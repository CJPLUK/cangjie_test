// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package com.java.lib

import java.lang.*;

@Java
foreign interface I {
    func foo(): I
    func foo(arg: I): Int
}

@Java
open foreign class T {
    init()
}

@Java
foreign class Arg {
    init()
    public func g(a: I): Int64
}

@Java
foreign class IImpl <: I {
    init()
    public func foo(): I
    public func foo(arg: I): Int
}


@Java
class Impl <: T {
    public init() {
        print("CJ: started\n", flush: true)
        let x = IImpl().foo()
        print("CJ: got x from IImpl().foo()\n", flush: true)
        let y = x.foo()
        print("CJ: got y from x.foo()\n", flush: true)
        let res = x.foo(y);
        print("CJ: got ${res} from x.foo(y)\n", flush: true)
        let gRes = Arg().g(x)
        println("CJ: got ${gRes} from Arg().g(x)")
        println("CJ: finished")
    }
}
