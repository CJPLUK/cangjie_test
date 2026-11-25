/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-003: the function-level auxiliary-variable rewrite must cover every
// compound-assignment operator and the standalone postfix/prefix update forms
// (`x++`, `++x`, `x--`, `--x`) inside a `@ghost` block.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [variable count: Int64 = 0]
func covAuxCompound(): Int64 {
    @ghost (
        count = 0
        count += 2
        count -= 1
        count *= 3
        count /= 2
        count %= 5
        count **= 1
        count <<= 1
        count >>= 1
        count &= 7
        count |= 8
        count ^= 1
        count++
        count--
    )
    return count
}

@Test
class Test {
    @TestCase
    func testAuxCompoundUpdate() {
        @Expect(covAuxCompound(), 8)
    }
}
