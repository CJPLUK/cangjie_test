// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output -Woff all
// EXEC: %run %run_opt %output %run_args

class C {
    var a: Int32
    let b: Int64 = -3
    init(a: Int32) { this.a = a }
    init(this @local!, a: Int32) {
        exclave {
            this.a = a
        }
    }
}

func test2(): C@local! {
    exclave {
        var c: C@local! = C(2)
        c
    }
}

main() {
    var f: C@local! = test2()
}
