// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A `(X.Y)...` whose `X.Y` is a dotted name parses `X.Y` as a (qualified) type
// candidate, so it becomes a forced-cast candidate. When `X.Y` is not a type but a
// callable -- a member function `obj.method`, a chained `a.b.method`, or a
// package-qualified callable value. Constructors use their canonical `Type(args)`
// spelling because a parenthesized type always selects forced-cast semantics.
// Regression guard: dotted callees previously crashed sema because the expression
// reading of a QualifiedType was not derived (only plain `RefType` names were).

import std.collection

class Obj {
    let base: Int64
    public init(base: Int64) { this.base = base }
    public func inc(x: Int64): Int64 { base + x }
    public func add(a: Int64, b: Int64): Int64 { base + a + b }
}

class Outer {
    public let obj: Obj
    public init(obj: Obj) { this.obj = obj }
}

main() {
    let o = Obj(100)
    // (obj.method)(args): obj.method is a member function -> ordinary call.
    let single = (o.inc)(1)
    let multi = (o.add)(2, 3)
    // Chained dotted callee (a.b.method)(args): nested QualifiedType.
    let outer = Outer(Obj(200))
    let chained = (outer.obj.inc)(5)
    // Package-qualified constructor uses the unambiguous `Type(args)` spelling.
    let built = collection.ArrayList<Int64>([7, 8, 9])

    if (single != 101 || multi != 105 || chained != 205 || built.size != 3) {
        throw Exception("qualified callee fallback failed")
    }
}
