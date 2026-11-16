// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct S <: Copyable {
    let field: Int64 = 7
    func implicit(this @local?): Int64 { spawn { field }.get() }
    func explicit(this @local?): Int64 { spawn { this.field }.get() }
    func paren(this @local!): Int64 { spawn { (this).field }.get() }
}
class C { let field: Int64 = 7 }
func copied(a: Int64 @local!, b: Int64 @local?): Int64 {
    spawn { a + b }.get()
}
main(): Int64 {
    let s: S @local? = S()
    let f: S @local! = S()
    if (s.implicit() != 7 || s.explicit() != 7 || f.paren() != 7) { return 1 }
    if (copied(2, 3) != 5) { return 2 }
    let c = C()
    if (spawn { c.field }.get() != 7) { return 3 }
    let own = spawn {
        let p: C @local? = C()
        let read = { => p.field }
        read()
    }.get()
    if (own != 7) { return 4 }
    return 0
}
