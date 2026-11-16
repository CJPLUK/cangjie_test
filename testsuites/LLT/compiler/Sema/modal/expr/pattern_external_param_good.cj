// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class F {
    init() {}
    init(this @local!) { exclave { } }
}
class G <: F {
    init() {}
    init(this @local!) { exclave { } }
    func foo(this @local!) { println("G::foo") }
}

func takeExternal(p: F@local!) {
    exclave {
        match (p) {
            case x: G => x.foo()
            case _ => ()
        }
    }
}

main() {
    takeExternal(G() @local!)
}
