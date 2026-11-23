/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-VAR-012: a struct-constructor label matching a ghost
// `variable` name is not rewritten. Fixed (defect 16.30; see
// contract-defects-audit.md): `Point(x: 3)` used to lose its label to the
// ghost-variable rewrite.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

struct Point {
    var x: Int64
    init(x!: Int64) {
        this.x = x
    }
}

@Contract [variable w: Int64 = 0]
func make(): Int64 {
    let p = Point(x: 3)
    return p.x + w
}

main() {
    if (make() != 3) {
        throw Exception("struct-constructor label was corrupted by the ghost rewrite")
    }
    println("ok")
}
