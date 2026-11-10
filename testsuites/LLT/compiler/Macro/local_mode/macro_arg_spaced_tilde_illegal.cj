// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_pass.cj
// EXEC: %compiler %cmp_macro define_pass.cj
// ERRCHECK: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output

// Regression for the bare-@ adjacency fix: '@~ local' in macro input matches
// the modal shape but the '~' and 'local' are not adjacent in the source, so
// HasMacroCallToEval and the bare-@ check must both treat it as non-modal
// (requireAdjacent = !reEval) and the input is diagnosed as illegal instead of
// being silently passed to the parse stage.

import define.*

main() {
    let t = @M(x @~ local)
    println(t)
    return 0
}

/* SCAN-IN
error:  illegal input tokens in macro call
*/
