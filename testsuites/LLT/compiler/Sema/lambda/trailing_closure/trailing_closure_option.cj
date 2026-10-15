// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func apply(g: ?(Int64) -> Int64): Int64 {
    match (g) {
        case Some(h) => h(40)
        case None => 0
    }
}

func call0(g: ?() -> Int64): Int64 {
    match (g) {
        case Some(h) => h()
        case None => 0
    }
}

func applyNested(g: Option<Option<(Int64) -> Int64>>): Int64 {
    match (g) {
        case Some(Some(h)) => h(1)
        case _ => 0
    }
}

main(): Int64 {
    var a = apply { x => x + 2 }
    var b = call0 { 42 }
    var c = call0() { 42 }
    var d = applyNested { x => x + 2 }
    return a - b + c + d - 45
}
