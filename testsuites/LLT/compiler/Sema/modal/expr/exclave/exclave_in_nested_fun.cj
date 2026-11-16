// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class S {
    init(this @local!) { exclave {} }
    public func toString(this @local!): String {
        "S"
    }
}

func foo(x: S @local!) {
    func goo1(y: S @local!): Unit {
        exclave {
            func goo2(z: S @local!): Unit {
                exclave {}
            }
            goo2(y)
        }
    }
    exclave {
        goo1(x)
    }
}

main() {}