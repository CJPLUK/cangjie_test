// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An unannotated lambda parameter starts as IDEAL (pending modal). When such a receiver
// calls a method with several this-mode overloads, resolution prefers the @~local (NOT)
// this-param candidate instead of leaving all modal overloads legal and ambiguous.
// The selected overload is observed through the printed value.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class C {
    init() {}
    init(this @local!) { exclave {} }

    func tag(this @~local): String {
        "not"
    }

    func tag(this @local!): String {
        "full"
    }
}

func bar() {
    let f = { x => x.tag() }
    println(f(C()))
}

main() {
    bar()
}

/* SCAN
not
*/
