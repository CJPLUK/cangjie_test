// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func f(cb!: ?(Int64) -> Int64 = None): Int64 {
    match (cb) {
        case Some(h) => h(1)
        case None => 0
    }
}

main(): Int64 {
    var a = f()
    var b = f(cb: None)
    var c = f { x => 41 }
    return a + b + c - 41
}
