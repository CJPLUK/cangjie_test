// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func apply(g: Option<CFunc<(Int64) -> Int64>>): Int64 {
    match (g) {
        case Some(h) => unsafe { h(1) }
        case None => 0
    }
}

main(): Int64 {
    var t = apply {x: Int64 => x + 2}
    return t - 3
}
