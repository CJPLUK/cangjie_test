/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-085: a constructor `@ghost` block may not call member
// functions. Exercises the token shapes of the member-call detection: bare
// `foo(`, explicit `this.foo(`, generic `foo<T>(`, a lone `foo < bar`
// comparison, a member name used as a value, a receiver other than this/super,
// a trailing bare member name and a nested `const func` local declaration.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan member function calls are not allowed in `@ghost` blocks of constructors
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable aux: Int64
]
class VCovNegGhostCall {
    VCovNegGhostCall(n: Int64) {
        @ghost(
            aux = n
            aux = helper(n)
            aux = this.helper(n)
            aux = helper<Int64>(n)
            if (helper < n) {
                aux = n
            }
            let f = helper
            const func inner(m: Int64): Int64 {
                m
            }
            aux = inner(n)
            other.helper(n)
            helper
        )
    }

    func helper(n: Int64): Int64 {
        n
    }
}

main() {
}
