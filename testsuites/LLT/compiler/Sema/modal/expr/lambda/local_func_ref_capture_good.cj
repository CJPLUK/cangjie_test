// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

func outer(): Int64 {
    let x: Int64 = 42
    @local? func read(): Int64 { x }
    @local? func user(): Int64 { ((read))() }
    let f = { => user() }
    func heap(): Int64 { x }
    func alias(): Int64 {
        let r = heap
        r()
    }
    if (f() != 42 || alias() != 42) { return 1 }
    return 0
}
main(): Int64 { outer() }
