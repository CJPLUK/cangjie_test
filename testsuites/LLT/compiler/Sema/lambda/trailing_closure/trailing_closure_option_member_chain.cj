// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

class C {
    init(cb: ?() -> Unit) {}

    func onClick(cb: ?(Int64) -> Unit): C {
        match (cb) {
            case Some(h) => h(0)
            case None => ()
        }
        this
    }

    func run(): Int64 {
        42
    }
}

main(): Int64 {
    var a = C() { }.onClick { e => () }.run()
    var g: (?() -> Unit) -> Unit = {
        cb => match (cb) {
            case Some(h) => h()
            case None => ()
        }
    }
    g { }
    return a - 42
}
