/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-068: a property whose setter parameter is not named `value` makes
// the accessor-contract parser rewrite bare `value` identifiers (including inside
// string interpolation) while leaving named-argument labels and qualifiers alone.
// Newlines inside the argument list exercise the separator-skipping scans of the
// named-argument helpers.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func tokCal(a!: Int64, b!: Int64): Int64 {
    a + b
}

func tokVal(value!: Int64): Int64 {
    value
}

@Contract [
    variable bound: Int64 = 10
]
class TokSetterHost {
    private var store: Int64 = 0

    public init() {}

    @Contract [
        get {
            ensures r: r >= 0
        }
        set {
            requires value >= 0
            ensures store == value
            ensures tokVal( value: 1 ) == 1
            ensures tokCal(
                a: 1,
                b: 2) == 3
            ensures tokCal(a: 1,
                b:
                value) == value + 1
            ensures "${value}".size > 0
            ensures bound >= 0
        }
    ]
    public mut prop gauge: Int64 {
        get() {
            store
        }
        set(v) {
            store = v
        }
    }
}

@Test
class Test {
    @TestCase
    func testSetterAliasRewrite() {
        let h = TokSetterHost()
        h.gauge = 5
        @Expect(h.gauge, 5)
    }
}
