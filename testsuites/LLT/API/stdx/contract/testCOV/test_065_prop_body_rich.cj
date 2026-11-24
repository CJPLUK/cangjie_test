/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-065: property accessor contract bodies must be scanned for nested
// braces (a `match` expression in `get`) and the setter alias rewrite must walk
// string interpolations, keeping member accesses and named-argument labels while
// renaming the bare `value` reference to the declared setter parameter.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func pick(value!: Int64): Int64 {
    value + 1
}

class CovHolder {
    public var value: Int64 = 0

    public init() {}
}

@Contract
class CovPropRich {
    private var store: Int64 = 0
    private let holder = CovHolder()

    public init() {}

    @Contract [
        get {
            ensures r: match (r) {
                case 0 => true
                case x => x >= 0
            }
        }
        set {
            requires holder.value >= 0
            ensures "${value}${holder.value}${pick(value: 1)}${pick(value: value)}" == "${value}${holder.value}${pick(value: 1)}${pick(value: value)}"
            ensures value >= 0
        }
    ]
    public mut prop amount: Int64 {
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
    func testPropertyAccessorRewrite() {
        let holder = CovPropRich()
        holder.amount = 5
        @Expect(holder.amount, 5)
    }
}
