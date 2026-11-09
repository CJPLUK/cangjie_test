// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class S {
    init(this @local!) { exclave {} }
    public func toString(this @local!): String {
        "S"
    }
}

func foo<T>(x: T @local!) where T <: S {
    func goo1(y: T @local!): Unit {
        func goo2(z: T @local!): Unit {
            exclave {
                print("goo2, x = ${z.toString()}")
            }
        }
        exclave {
            goo2(y)
        }
    }
    exclave {
        goo1(x)
    }
}

main() {
    var a = S()@local!
    foo(a)
    return 0
}