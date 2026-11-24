/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-075: token generation for contract bodies whose lambdas, `match` and
// `try` expressions are split across lines, including lambdas and array
// literals inside a `@ghost` block.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [ variable acc: Int64 = 0 ]
class Probe {
    public init() {}

    @Contract [ requires x >= 0
                ensures r: r >= 0 ]
    public func run(x: Int64): Int64 {
        let g = {a: Int64,
                 b: Int64 => a + b}
        let h = {m: Array<Array<Int64>> => m.size}
        let arr = [[1, 2], [3]]
        @ghost (
            {a: Int64,
             b: Int64 => a + b}(1, 2)
            {m: Array<Array<Int64>> => m.size}(arr)
        )
        let c = match (Some(x)) {
            case Some(
                v
            ) => v
            case
                _ => 0
        }
        let d = try {
            throw Exception("e")
        } catch (
            e: Exception
        ) {
            0
        }
        g(x, 1) + h(arr) + c + d
    }
}

@Test
class Test {
    @TestCase
    func testProbe() {
        @Expect(Probe().run(3), 4 + 2 + 3 + 0)
    }
}
