// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An unannotated lambda parameter adopts the @local? modal of the lambda's own type annotation.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class C {
    init() {}
    init(this @local?) { exclave {} }

    func tag(this @local?): String {
        "half"
    }
}

func take(c: C @local?): String {
    c.tag()
}

main() {
    let f: (C @local?) -> String = { x => take(x) }
    let c: C @local? = C()
    println(f(c))
}

/* SCAN
half
*/
