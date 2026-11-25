/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-033: named-parameter methods under contracts exercise the
// named-argument label assembly; `mut func` in an interface goes through the
// struct-member generator; a `mut prop` with a `set` contract covers the
// setter parameter assembly.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [ invariant ok >= 0 ]
class CovNamed {
    public var ok: Int64 = 0
    public init() {}

    @Contract [ requires a > 0 ]
    public func m(a!: Int64): Int64 {
        a
    }

    @Contract [
        get requires true
        set ensures true
    ]
    public mut prop p: Int64 {
        get() {
            ok
        }
        set(v) {
            ok = v
        }
    }
}

@Contract []
interface CovMutIface {
    @Contract [ requires x > 0 ]
    mut func touch(x: Int64): Unit
}

class CovMutImpl <: CovMutIface {
    public var seen: Int64 = 0
    public init() {}
    public func touch(x: Int64): Unit {
        seen = x
    }
}

@Test
class Test {
    @TestCase
    func testNamedAndMut() {
        let c = CovNamed()
        @Expect(c.m(a: 3), 3)
        c.p = 5
        @Expect(c.p, 5)
        let impl = CovMutImpl()
        impl.touch(2)
        @Expect(impl.seen, 2)
    }
}
