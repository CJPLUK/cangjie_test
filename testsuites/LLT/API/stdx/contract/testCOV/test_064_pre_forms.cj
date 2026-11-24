/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-064: the `$pre` snapshot scanner must handle nested parentheses,
// square-bracket groups (array literals), newlines and trailing commas inside
// the snapshot expression.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func square(xs: Array<Int64>): Int64 {
    var s = 0
    for (x in xs) {
        s += x
    }
    s
}

@Contract [
    ensures $pre(square([1, 2, 3])) == 6
]
func covPreSquare(r: Int64): Int64 {
    r
}

@Contract [
    ensures $pre(
        1 + 2
    ) == 3
]
func covPreNewline(r: Int64): Int64 {
    r
}

@Contract [
    ensures $pre((1 + 2)) == 3
]
func covPreGrouped(r: Int64): Int64 {
    r
}

@Test
class Test {
    @TestCase
    func testPreSnapshotForms() {
        @Expect(covPreSquare(1), 1)
        @Expect(covPreNewline(1), 1)
        @Expect(covPreGrouped(1), 1)
    }
}
