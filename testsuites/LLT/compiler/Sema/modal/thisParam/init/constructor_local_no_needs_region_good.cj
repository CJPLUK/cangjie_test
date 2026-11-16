// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

class C {
    var n = 0
    init() {}
    init(this @local!) {
        exclave {
            n = 0
        }
    }
}

func run() {
    exclave {
        C()@local!
    }
}

main(): Int64 {
    run()
    0
}
