// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args

exclave func foo(a: ((Int64) -> Int64) @local?) {
    let p = 3
    @local? func bar(x: Int64) {
        x + p
    }
    a ~> bar
}

main() {
    let r = 40 |> foo {
        x => x + 1
    }
    println(r)
}