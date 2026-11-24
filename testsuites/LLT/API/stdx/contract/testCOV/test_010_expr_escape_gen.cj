/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-010: contract conditions containing string interpolation with
// escape sequences and nested generic types exercise the interpolation
// rewriter's escape handling and the type-context state machine.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    requires s == "a\tb${n}c\$d"
]
func covEsc(n: Int64, s: String): Bool {
    true
}

@Contract [
    requires v is Array<Array<Int64>>
]
func covNestedGen(v: Any): Bool {
    v is Array<Array<Int64>>
}

@Contract [
    variable f: (Int64) -> Int64 = {x => x * 2}
    variable g: (Int64) -> Int64 = {x => x + 1}
    ensures r: r == 3
]
func covFnVar(x: Int64): Int64 {
    3
}

@Test
class Test {
    @TestCase
    func testEscapesAndGenerics() {
        @Expect(covEsc(1, "a\tb1c$d"), true)
        let nested: Array<Array<Int64>> = [[]]
        @Expect(covNestedGen(nested), true)
        @Expect(covFnVar(1), 3)
    }
}
