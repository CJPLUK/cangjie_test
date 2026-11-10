// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_pass.cj
// EXEC: %compiler %cmp_macro define_pass.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// Positive control for macro_arg_spaced_tilde_illegal.cj: the adjacent form
// '@~local' inside macro input IS a modal, so the bare-@ diagnostic must not
// fire and the macro call evaluates normally.

import define.*

main() {
    let t = @M(x @~local)
    println(t)
    return 0
}
