// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class NC {
    var n: Int64 = 0
    init() {}
    init(this @local!) { exclave { n = 0 } }
}

enum E {
    | A(NC)
}

class Worker {
    init() {}
    init(this @local!) { exclave { } }

    func run(this @local!): Int64 {
        exclave {
            let x = E.A(NC()@local!) @local!
            match (x) {
                case E.A(v) => v.n
            }
        }
    }
}

func test() {
    Worker()@local!.run()
}

main(): Int64 {
    test()
}
