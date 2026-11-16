// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface I {
    public func pick(this @~local): Int64
    public func pick(this @local!): Int64
    public func pick(this @local?): Int64
}
struct K <: Copyable & I {
    public func pick(this @~local): Int64 { 11 }
    public func pick(this @local!): Int64 { 33 }
    public func pick(this @local?): Int64 { 22 }
}
class C <: I {
    init() {}
    init(this @local!) { exclave {} }
    init(this @local?) { exclave {} }
    public func pick(this @~local): Int64 { 11 }
    public func pick(this @local!): Int64 { 33 }
    public func pick(this @local?): Int64 { 22 }
}
func cond(): Bool { true }
func returnBranch(flag: Bool): Int64 {
    let a: K @local! = K()
    let v = if (flag) { a } else { return 77 }
    v.pick()
}
func reverseReturnBranch(flag: Bool): Int64 {
    let a: K @local! = K()
    let v = match (flag) {
        case true => return 77
        case _ => a
    }
    v.pick()
}
main(): Int64 {
    let a: K @local! = K()
    let b: K @~local = K()
    let h: K @local? = K()
    let ab = if (cond()) { a } else { b }
    let ba = if (cond()) { b } else { a }
    let aa = if (cond()) { a } else { a }
    let bb = if (cond()) { b } else { b }
    let ah = if (cond()) { a } else { h }
    let m = match (cond()) { case true => a; case _ => b }
    if (ab.pick() != 22 || ba.pick() != 22 || aa.pick() != 33 || bb.pick() != 11) { return 1 }
    if (ah.pick() != 22 || m.pick() != 22) { return 2 }
    let cf = C() @local!
    let ch = C()
    let cp = C() @local?
    let x = if (cond()) { cf } else { b }
    let y = if (cond()) { a } else { ch }
    let z = if (cond()) { b } else { cp }
    let r = if (cond()) { b } else if (cond()) { a } else { cf }
    if (x.pick() != 33 || y.pick() != 11 || z.pick() != 22 || r.pick() != 33) { return 3 }
    let thrown = if (cond()) { a } else { throw Exception() }
    let reverseThrown = if (!cond()) { throw Exception() } else { a }
    let matchedThrow = match (cond()) { case true => a; case _ => throw Exception() }
    let matchedReturn = match (cond()) { case true => a; case _ => return 4 }
    if (thrown.pick() != 33 || reverseThrown.pick() != 33 || matchedThrow.pick() != 33 ||
        matchedReturn.pick() != 33) { return 5 }
    if (returnBranch(true) != 33 || returnBranch(false) != 77 ||
        reverseReturnBranch(false) != 33 || reverseReturnBranch(true) != 77) { return 6 }
    return 0
}
