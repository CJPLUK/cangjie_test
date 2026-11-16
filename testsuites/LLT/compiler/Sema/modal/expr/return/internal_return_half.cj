// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class F {
    let p: Int = 1
    init() {}
    exclave init(this @local?) { }
}
exclave func foo(): F@local? {
    let b: F@local? = F()
    b
}
exclave func bar(): F@local? {
    let c: F@local? = F()
    return c
}

main() {
    foo()
    bar()
    0
}
