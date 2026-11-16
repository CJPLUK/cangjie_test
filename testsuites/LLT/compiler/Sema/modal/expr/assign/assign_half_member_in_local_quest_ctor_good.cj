// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class D {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

class C {
    var d: D
    init() { d = D() }
    init(this @local?) {
        exclave {
            d = D()@local?
            this.d = D()@local?
        }
    }
}

main(): Int64 {
    C()@local?
    0
}
