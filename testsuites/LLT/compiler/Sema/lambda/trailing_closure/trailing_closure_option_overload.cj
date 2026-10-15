// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func f(cb: () -> Int64): Int64 {
    cb() + 1
}

func f(cb: ?() -> Int64): Int64 {
    match (cb) {
        case Some(g) => g() + 2
        case None => 0
    }
}

func g<T>(cb: T): Int64 {
    100
}

func g(cb: () -> Int64): Int64 {
    1
}

func outer(cb: () -> String): String {
    "outer F"
}

func pick(): String {
    func outer(cb: ?() -> String): String {
        match (cb) {
            case Some(h) => h()
            case None => "none"
        }
    }
    return outer { "inner Option<F>" }
}

main(): Int64 {
    var a = f { 41 }
    var b = f({ => 41 })
    var c = g { 0 }
    if (pick() != "inner Option<F>") {
        return 1
    }
    return a + b + c - 85
}
