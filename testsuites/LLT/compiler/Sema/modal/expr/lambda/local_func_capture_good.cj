// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class F {
    let a = 1
    init() {}
    init(this @local?) { exclave { } }
}

func f() {
    let x: F@local? = F()
    @local? func h() {
        println(x.a)
    }
    h()
}

main() {
    f()
}
