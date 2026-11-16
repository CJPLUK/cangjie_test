// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An unannotated lambda parameter (IDEAL receiver) calling a method that only has @local! and
// @local? this-mode overloads resolves without ambiguity; the @local? candidate is selected when
// no @~local candidate exists.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class C {
    init() {}
    init(this @local!) { exclave {} }
    init(this @local?) { exclave {} }

    func tag(this @local!): String {
        "full"
    }

    func tag(this @local?): String {
        "half"
    }
}

func run() {
    let f = { x => x.tag() }
    println(f(C()))
}

main() {
    run()
}

/* SCAN
half
*/
