// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

var count: Int64 = 0
func bump(): Int64 {
    count += 1
    count
}

class C {
    public var x: Int64 = bump()
    init(p: Int64) { x = p }
    init() { this(42) }
    init(this @local!, p: Int64) { exclave { x = p } }
    init(this @local!) { exclave { this(42) } }
    init(this @local?, p: Int64) { exclave { x = p } }
    init(this @local?) { exclave { this(42) } }
}

struct S {
    public var x: Int64 = bump()
    init(p: Int64) { x = p }
    init() { this(42) }
    init(this @local!, p: Int64) { exclave { x = p } }
    init(this @local!) { exclave { this(42) } }
    init(this @local?, p: Int64) { exclave { x = p } }
    init(this @local?) { exclave { this(42) } }
}

class Parenthesized {
    public var x: Int64 = bump()
    init(this @local!, p: Int64) { exclave { x = p } }
    init(this @local!) { (((exclave { ((this(42))) }))) }
}

class Modified {
    public var x: Int64 = bump()
    exclave init(this @local!, p: Int64) { x = p }
    exclave init(this @local!) { this(42) }
}

main(): Int64 {
    let c = C() @local!
    if (count != 1 || c.x != 42) { return 1 }
    let s = S() @local!
    if (count != 2 || s.x != 42) { return 2 }
    let cm = C() @local?
    if (count != 3 || cm.x != 42) { return 3 }
    let sm = S() @local?
    if (count != 4 || sm.x != 42) { return 4 }
    let ch = C()
    if (count != 5 || ch.x != 42) { return 5 }
    let sh = S()
    if (count != 6 || sh.x != 42) { return 6 }
    let p = Parenthesized() @local!
    if (count != 7 || p.x != 42) { return 7 }
    let m = Modified() @local!
    if (count != 8 || m.x != 42) { return 8 }
    return 0
}
