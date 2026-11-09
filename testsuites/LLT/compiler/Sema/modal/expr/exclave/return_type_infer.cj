// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface S {
    func toString(this @local!): String
}
class A {
    public static func foo<U>(x: U@local!) where U <: S {
        exclave {
            println("A::foo, x=${x.toString()}")
        }
    }
}

func bar<U>(x: U@local!) where U <: S {
    exclave {
        println("bar, x=${x.toString()}")
    }
}
main() {}
