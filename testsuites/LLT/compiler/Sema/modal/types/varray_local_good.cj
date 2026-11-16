// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC-1: %run %run_opt %output %run_args

func foo(): VArray<Int64, $3> @local? {
    VArray<Int64, $3> { i => i }
}

func bar(): VArray<Int64, $2> @local! {
    VArray<Int64, $2> { i => i + 1 }
}

main(): Int64 {
    foo()[0] + bar()[0]
}
