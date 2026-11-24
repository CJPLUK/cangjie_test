// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %diag_json %f -o %output
// EXEC: %run %run_opt %output %run_args

class Runner {
    var calls: Int64 = 0

    operator func ()(callback: Option<() -> Int64>): Int64 {
        calls += 1
        match (callback) {
            case Some(fn) => fn()
            case None => -1
        }
    }

    operator func ()(value: Int64, callback: Option<(Int64) -> Int64>): Int64 {
        calls += 1
        match (callback) {
            case Some(fn) => fn(value)
            case None => value
        }
    }
}

main(): Int64 {
    let runner = Runner()
    if (runner { 42 } != 42) { return 1 }
    if (runner() { => 43 } != 43) { return 2 }
    if (runner(10) { x => x + 1 } != 11) { return 3 }
    if (runner.calls != 3) { return 4 }
    return 0
}
