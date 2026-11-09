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

// With the current map overloads, inference selects TreeMap<String, Int64>.
// Passing a HashMap then reports a type mismatch at the call site.

/* SCAN
error: mismatched types
  ==> lambda_param_sum_keep_04.cj:22:7:
   | 
22 |     f(h)
   |       ^ expected 'Class-TreeMap<Struct-String, Int64>', found 'Class-HashMap<Struct-String, Int64>'
   | 

1 error generated, 1 error printed.
*/
