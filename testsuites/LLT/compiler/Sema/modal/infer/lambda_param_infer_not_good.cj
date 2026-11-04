// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An unannotated lambda parameter adopts the @~local modal of the callee's formal.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class C {
    init() {}
}

func take(c: C @~local): String {
    "not"
}

main() {
    let f = { x => take(x) }
    let c: C @~local = C()
    println(f(c))
}

/* SCAN
not
*/
