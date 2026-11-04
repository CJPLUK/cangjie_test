// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC-1: %run %run_opt %output %run_args

func half(n: Int64): VArray<Int64, $2> @local? {
    VArray<Int64, $2> { i => i + n }
}

func full(n: Int64): VArray<Int64, $2> @local! {
    VArray<Int64, $2> { i => i + n + 1 }
}

func use(h: VArray<Int64, $2> @local?, f: VArray<Int64, $2> @local!): Int64 {
    h[0] + f[0]
}

main(): Int64 {
    let _ = use(half(0), full(0))
    1
}
