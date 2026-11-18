/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-014: a named-argument VALUE matching an auxiliary `variable` name is
// still rewritten to the ghost read (`g(x: x)` must pass the aux slot value).
// Fixed (audit report 3, R2): the type-position heuristic treated everything
// after a colon as a type, so `x` in the value position stayed unrewritten and
// failed with `undeclared identifier 'x'`.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func g(x!: Int64): Int64 {
    return x
}

@Contract [variable x: Int64 = 1]
func auxValue(): Int64 {
    return g(x: x)
}

main() {
    if (auxValue() != 1) {
        throw Exception("named-argument value was not rewritten to the ghost read")
    }
    println("ok")
}
