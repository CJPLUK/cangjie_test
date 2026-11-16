// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    var m = 1
    init(this @local?) { exclave { } }

    prop p: Int64 @local? {
        get() { m }
    }

    func bar(this @local?) {
        let h = { => println(p) }
        let _: (()->Unit)@local? = h
        h()
    }
}

main() {
    C()@local?.bar()
}
