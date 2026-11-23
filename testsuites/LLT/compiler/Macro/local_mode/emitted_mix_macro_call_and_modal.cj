// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_mix.cj
// EXEC: %compiler %cmp_macro define_mix.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// Macro output mixes a nested macro call with a modal: '@N' must be re-evaluated
// (pass-through), while '@local!' must be kept as a modal and glued, not judged
// a macro call to 'local'. If the two are confused the expansion either fails
// with an unknown-macro/local error or drops the modal and the re-parse breaks.

import define.*

@M
func dummy() {}

main() {
    println(gen())
    return 0
}
