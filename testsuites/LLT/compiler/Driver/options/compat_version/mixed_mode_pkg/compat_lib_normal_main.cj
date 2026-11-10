// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A library built in compat mode can be used by a program built in normal mode.
// DEPENDENCE: lib
// EXEC: %compiler %cmp_opt --compat-version 1.3 %pkg_opt lib %compile_lib_opt -o ./
// EXEC: %compiler %cmp_opt %f liblib.a -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// ASSERT: scan 3

import lib.*

main() {
    println(add(1, 2))
    return 0
}
