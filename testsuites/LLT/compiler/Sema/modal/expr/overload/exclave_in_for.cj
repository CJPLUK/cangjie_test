// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

func foo() {
    18
}

class C {
    init() {}
    init(this @local?) { exclave {} }

    var p = 1
}
func car(a: C@local!) {
    let x: Int64 = a.p
    for (i in x..foo()) {
        if (i == 10) {
            return
        }
        println(i)
    }
}

main() {}