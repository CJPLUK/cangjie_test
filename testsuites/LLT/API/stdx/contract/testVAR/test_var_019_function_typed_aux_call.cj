/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-019 (audit H7): a function-typed auxiliary variable must be read from
// its slot before being called. `f(...)` used to be mistaken for a call/label
// position, so the access was not rewritten and the compiler reported
// `undeclared identifier 'f'` in contract expressions and `@ghost`.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable inc: (Int64) -> Int64 = { value => value + 1 }
    requires inc(0) == 1
    ensures r: inc(r - 1) == r
]
func varFnAux(x: Int64): Int64 {
    x
}

@Contract [
    variable double: (Int64) -> Int64 = { value => value * 2 }
    variable out: Int64 = 0
    ensures out == 42
]
func varFnAuxGhost(x: Int64): Unit {
    @ghost(out = double(x))
}

@Test
class Test {
    @TestCase
    func testVar019FunctionTypedAuxCall() {
        @Expect(varFnAux(41), 41)
        varFnAuxGhost(21)
    }
}
