// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: %n.pkg.cj
// EXEC: %compiler %local %n.pkg.cj %compile_lib_opt -o %n.%middle
// EXEC: %compiler %local %f -o %output %n.%middle
// RUN-EXEC: %run %run_opt %output %run_args

import pkga.*

func foo(): A@local! {
    let k: A@~local = A()
    k
}

main() {
    let a: A@local! = A()
    foo()
    let b: A@~local = a
    b.x - 1
}
