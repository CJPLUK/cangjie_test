/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-069: setter alias rewriting must keep named-argument labels even when
// the label is separated from `(` or its `:` by a line break, and must walk string
// interpolations with escape sequences and nested braces.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func tokAliasGen(value!: Int64): Int64 {
    value
}

@Contract
class CovTokAliasGen {
    private var store: Int64 = 0

    public init() {}

    @Contract [
        get ensures r: r >= 0
        set {
            ensures tokAliasGen(
                value: 1
            ) == 1
            ensures tokAliasGen(value: 2) == 2
            ensures tokAliasGen(value
                : 3) == 3
            ensures "\\${value}".size >= 0
            ensures "\n${value}".size >= 0
            ensures "${if (value > 0) { value } else { 0 }}".size >= 0
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
    func testAliasRewrite() {
        let c = CovTokAliasGen()
        c.amount = 7
        @Expect(c.amount, 7)
    }
}
