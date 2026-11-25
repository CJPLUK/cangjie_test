/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-001: the function-level auxiliary-variable rewrite and the shadowing
// validator must scan destructuring groups, multiple-assignment targets, nested
// and `const` local functions, lambdas, `match` bindings, `catch` bindings and
// `for-in` bindings inside a contract-bearing function body.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [variable count: Int64 = 0]
func covAuxDestructure(n: Int64): Int64 {
    var (a, b) = (1, 2)
    (a, b) = (b, a)
    const func helper(p: Int64): Int64 {
        p + 1
    }
    func nest(q: Int64): Int64 {
        q + 2
    }
    let lam = { r: Int64 => r + 3 }
    let matched = match (n) {
        case 0 => helper(n)
        case _ => nest(n)
    }
    try {
        throw Exception("cov")
    } catch (caught: Exception) {
        @ghost(count += 1)
    }
    for (index in 0..n) {
        @ghost(count += index)
    }
    @ghost(
        let (c, d) = (a, b)
        count += c + d
    )
    lam(matched) + count + a + b
}

@Test
class Test {
    @TestCase
    func testAuxDestructure() {
        // After the swap a=2, b=1; the count becomes 1 (catch) + 3 (for-in)
        // + 3 (ghost destructuring) = 7, and lam(nest(3)) = 8, so the result is
        // 8 + 7 + 2 + 1 = 18.
        @Expect(covAuxDestructure(3), 18)
    }
}
