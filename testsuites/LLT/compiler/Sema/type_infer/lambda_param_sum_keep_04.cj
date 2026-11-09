// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1:%frontendCompiler %typecheck %cmp_opt -Woff all %f 2>&1 | compare %f

// Guard for the issue #927 fix: coverage is the UNION over all member usages
// of the same lambda param. `m["k"]` alone covers only K of map-like types,
// but `m.add("k", 1)` covers both K and V, so map-like candidates must stay in
// the sum and the diagnostic must be identical to the behavior before the fix.

import std.collection.*

func use(): Unit {
    let f = {m =>
        m.add("k", 1)
        m["k"]
    }
    let h = HashMap<String, Int64>()
    f(h)
    return
}

main() {
    use()
    return 0
}

// The 2026-10-23 compiler change (fix: exclave init check) settles the lambda
// parameter inference: with two map-like candidates still in the sum the
// parameter stays ambiguous and the diagnostic is the same as in the sibling
// guards (lambda_param_sum_keep_01/02/03). The earlier `mismatched types` at
// `f(h)` is no longer reachable, so the case pins the current text instead.

/* SCAN
error: parameters of this lambda expression must have type annotations
  ==> lambda_param_sum_keep_04.cj:17:14:
   | 
17 |     let f = {m =>
   |              ^ 
   | 

1 error generated, 1 error printed.
*/
