/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-009: exit checks for `ensures` must be injected before every bare
// `return`, including returns nested in loops, match cases, try/catch and
// `unsafe` blocks.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

@Contract[
    ensures r: r >= 0
]
func covEnsWhile(x: Int64): Int64 {
    while (x > 10) {
        return x
    }
    1
}

@Contract[
    ensures r: r >= 0
]
func covEnsDoWhile(x: Int64): Int64 {
    var i = 0
    do {
        if (x > 5) {
            return x
        }
        i += 1
    } while (i < 3)
    0
}

@Contract[
    ensures r: r >= 0
]
func covEnsFor(n: Int64): Int64 {
    for (i in 0..n) {
        if (i > 0) {
            return i
        }
    }
    0
}

@Contract[
    ensures r: r >= 0
]
func covEnsIfElse(x: Int64): Int64 {
    if (x > 0) {
        return x
    } else {
        return 0
    }
}

@Contract[
    ensures r: r >= 0
]
func covEnsElseIf(x: Int64): Int64 {
    if (x > 0) {
        return x
    } else if (x == 0) {
        return 0
    } else {
        return 0
    }
}

@Contract[
    ensures r: r >= 0
]
func covEnsMatch(x: Int64): Int64 {
    match (x) {
        case 0 => return 0
        case _ => return x
    }
}

@Contract[
    ensures r: r >= 0
]
func covEnsTryCatch(x: Int64): Int64 {
    try {
        if (x > 0) {
            return x
        }
        throw Exception("negative")
    } catch (e: Exception) {
        return 0
    } finally {
        if (x < -100) {
            println("finally")
        }
    }
    0
}

@Contract[
    ensures r: r >= 0
]
func covEnsUnsafe(x: Int64): Int64 {
    unsafe {
        if (x > 0) {
            return x
        }
    }
    0
}

@Contract[
    ensures r: r >= 0
]
func covEnsLocalFunc(x: Int64): Int64 {
    func inner(): Int64 {
        return 1
    }
    if (x > 0) {
        return inner()
    }
    0
}

@Test
class Test {
    @TestCase
    func testCovEnsWhile() {
        @Expect(covEnsWhile(20), 20)
        @Expect(covEnsWhile(1), 1)
    }

    @TestCase
    func testCovEnsDoWhile() {
        @Expect(covEnsDoWhile(10), 10)
        @Expect(covEnsDoWhile(0), 0)
    }

    @TestCase
    func testCovEnsFor() {
        @Expect(covEnsFor(3), 1)
        @Expect(covEnsFor(0), 0)
    }

    @TestCase
    func testCovEnsIfElse() {
        @Expect(covEnsIfElse(5), 5)
        @Expect(covEnsIfElse(-1), 0)
    }

    @TestCase
    func testCovEnsElseIf() {
        @Expect(covEnsElseIf(5), 5)
        @Expect(covEnsElseIf(0), 0)
        @Expect(covEnsElseIf(-1), 0)
    }

    @TestCase
    func testCovEnsMatch() {
        @Expect(covEnsMatch(0), 0)
        @Expect(covEnsMatch(5), 5)
    }

    @TestCase
    func testCovEnsTryCatch() {
        @Expect(covEnsTryCatch(5), 5)
        @Expect(covEnsTryCatch(-1), 0)
    }

    @TestCase
    func testCovEnsUnsafe() {
        @Expect(covEnsUnsafe(5), 5)
        @Expect(covEnsUnsafe(-1), 0)
    }

    @TestCase
    func testCovEnsLocalFunc() {
        @Expect(covEnsLocalFunc(5), 1)
        @Expect(covEnsLocalFunc(-5), 0)
    }
}
