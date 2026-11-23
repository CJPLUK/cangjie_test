/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-REQ-paren-call: a call written as `(g)(1)` inside a contract condition
// used to be misparsed as a second loop-invariant expression ("multiple loop
// invariant expressions"); the adjacent-parentheses heuristic was removed
// (audit report 2 #35).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func reqParenG(x: Int64): Int64 { return x + 1 }

@Contract [requires (reqParenG)(1) > 0]
func reqParenCall(): Int64 { return 0 }

main() {
    if (reqParenCall() != 0) {
        throw Exception("body did not run")
    }
    println("ok")
}
