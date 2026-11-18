/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-030: inside a constructor `@ghost` block a member written earlier in
// the same block can be read afterwards; the initializer-flow validator used
// to report a spurious "read before initialized" for the read (audit report 2
// #25).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func ghostObserve(v: Int64): Bool { return v == 1 }

@Contract[]
class ClsCtorGhostWriteRead {
    var v: Int64 = 0
    public init() {
        @ghost (
            v = 1
            @contractAssert(ghostObserve(v))
        )
    }
}

main() {
    let _ = ClsCtorGhostWriteRead()
    println("ok")
}
