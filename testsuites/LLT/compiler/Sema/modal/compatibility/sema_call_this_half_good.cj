// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_class.cj
// EXEC: %compiler %local %compile_lib_opt pkg_class.cj -o pkg_class.%middle
// EXEC: %compiler %cmp_opt pkg_class.%middle %f -o %output
// RUN-EXEC: %run %run_opt %output

import pkg_class.*

main() {
    let f = C().mHalf
    println(f())
    println(C().mHalf())
}
