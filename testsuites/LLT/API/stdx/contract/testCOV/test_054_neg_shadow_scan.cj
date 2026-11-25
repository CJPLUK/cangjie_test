/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-054: member bodies that rebind the name of a function-level
// contract `variable` in every declaration form the shadow scanner knows about:
// let/var, for bindings, nested func name and parameter, plain and typed lambdas,
// match case patterns, catch bindings and destructuring groups (declaration and
// multiple assignment). Also exercises the in-body ghost/assert/loop-invariant
// range scan performed by the type-level expansion.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract variable `acc` is shadowed by a local declaration; rename one of them
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract []
class ShadowHost {
    public init() {}

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func letShadow(x: Int64): Int64 {
        let acc = x
        acc
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func varShadow(x: Int64): Int64 {
        var acc = x
        acc
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func forShadow(x: Int64): Int64 {
        for (acc in 0..x) {
        }
        x
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func funcShadow(x: Int64): Int64 {
        func acc(y: Int64): Int64 {
            y
        }
        acc(x)
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func lambdaShadow(x: Int64): Int64 {
        let f = {acc => acc + 1}
        f(x)
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func typedLambdaShadow(x: Int64): Int64 {
        let f = {acc: Int64 => acc * 2}
        f(x)
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func caseShadow(x: Int64): Int64 {
        match (x) {
            case acc => acc
        }
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func catchShadow(x: Int64): Int64 {
        try {
            if (x < 0) {
                throw Exception("neg")
            }
            x
        } catch (acc: Exception) {
            0
        }
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func destructureShadow(x: Int64): Int64 {
        let (acc, b) = (x, 1)
        acc + b
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func assignDestructureShadow(x: Int64): Int64 {
        var acc = 0
        var b = 0
        (acc, b) = (x, 1)
        acc + b
    }

    @Contract [
        variable acc: Int64 = 0
        ensures r: r >= 0
    ]
    public func defaultShadow(x: Int64): Int64 {
        let acc = x
        acc
    }
}

main() {
}
