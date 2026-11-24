/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-066: a property contract declaring a `variable` clause exercises
// the property-level variable validation path.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class CovPropVar {
    public var base: Int64 = 1
    public init() {}

    @Contract [
        get {
            variable probe: Int64 = base + 1
            requires probe > 0
            ensures r: r == base
        }
    ]
    public prop reading: Int64 {
        get() {
            base
        }
    }

    @Contract [
        set {
            variable cap: Int64 = 100
            ensures true
        }
    ]
    public mut prop writing: Int64 {
        get() {
            base
        }
        set(v) {
            base = v
        }
    }
}

@Test
class Test {
    @TestCase
    func testPropVar() {
        let c = CovPropVar()
        @Expect(c.reading, 1)
        c.writing = 7
        @Expect(c.writing, 7)
    }
}
