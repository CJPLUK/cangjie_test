/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-011: literal forms in contract conditions (float, rune, string
// interpolation), catch bindings and tuple destructuring inside ghost
// collection, nested ghost updates in loops, and a valid `$pre` snapshot.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    requires f > 0.5
    requires s == "str${n}"
    requires c == 'x'
]
func covZoo(n: Int64, f: Float64, s: String, c: String): Bool {
    true
}

@Contract [
    variable acc: Int64 = 0
    ensures r: r == 3
]
func covZooCatchTuple(): Int64 {
    try {
        throw Exception("e")
    } catch (e: Exception) {
        let m = e.message
        ()
    }
    let (p, q) = (1, 2)
    @ghost ( acc = p + q )
    3
}

@Contract [
    variable seen: Int64 = 0
    ensures r: r == n
]
func covZooLoops(n: Int64): Int64 {
    var i = 0
    while (i < n) {
        i += 1
    }
    for (j in 0..n) {
        @ghost ( seen += 1 )
    }
    n
}

@Contract [ ensures r: r > $pre(n) ]
func covZooPre(n: Int64): Int64 {
    n + 1
}

@Test
class Test {
    @TestCase
    func testZoo() {
        @Expect(covZoo(1, 2.0, "str1", "x"), true)
        @Expect(covZooCatchTuple(), 3)
        @Expect(covZooLoops(4), 4)
        @Expect(covZooPre(1), 2)
    }
}
