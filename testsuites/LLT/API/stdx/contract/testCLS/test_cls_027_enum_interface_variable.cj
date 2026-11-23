/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-CLS-027 (negative, EXEC-PIPE-1): an enum cannot implement an interface
// that declares a class-level auxiliary variable — the expansion generates an
// abstract storage property the enum cannot implement
// (`implementation of function or property is needed in 'ClsColor'`).
// Known limitation, audit 16.7; pinned here per EXEC-PIPE-1.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan implementation of function or property is needed in 'ClsColor'
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract[
    variable v: Int64 = 1
    invariant [C27] v >= 0
]
interface ClsVarI {
    func touch(): Int64
}

enum ClsColor <: ClsVarI {
    Red | Green

    public func touch(): Int64 {
        1
    }
}

main() {
    println("unreachable")
}
