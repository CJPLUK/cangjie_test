/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-072: a struct `mut` method contract must forward its extra
// parameters (including named parameters) and generic type arguments to the
// hoisted mut body helper.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract
struct CovTokStructMut {
    public var acc: Int64 = 0

    public init() {}

    @Contract [
        requires a > 0
        ensures r: r >= a
    ]
    public mut func add(a: Int64, b!: Int64): Int64 {
        acc += a + b
        acc
    }

    @Contract [
        requires n > 0
    ]
    public mut func bump<T>(v: T, n!: Int64): Unit {
        acc += n
        v
    }
}

@Test
class Test {
    @TestCase
    func testStructMutForwarding() {
        var s = CovTokStructMut()
        @Expect(s.add(1, b: 2), 3)
        s.bump<Int64>(0, n: 4)
        @Expect(s.acc, 7)
    }
}
