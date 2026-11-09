/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖设计项（LM-DOC-20260910）：T433。

main(): Int64 {
    var failed = 0

    var caughtExact = false
    try {
        throw UnimplementedException()
        failed += 1
        println("FAIL: T433_noarg_exact_type — expected UnimplementedException")
    } catch (e: UnimplementedException) {
        caughtExact = true
    }
    failed += assertB(caughtExact, "T433_noarg_exact_type")

    var caughtParent = false
    try {
        throw UnimplementedException("sentinel")
        failed += 1
        println("FAIL: T433_message_parent_type — expected Exception")
    } catch (e: Exception) {
        caughtParent = true
        failed += assertEq(e.message, "sentinel", "T433_message_preserved")
    }
    failed += assertB(caughtParent, "T433_parent_type")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
