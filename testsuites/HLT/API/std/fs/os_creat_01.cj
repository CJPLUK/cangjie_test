/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj test_fj.txt test_fj_notnull.txt
// (!target_mac & !target_win) EXEC-PIPE: %compiler %cmp_opt caserunner.cj -o %output %f
// (!target_mac & !target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_mac & !target_win) ASSERT: scan-not AssertionError
import std.posix.*

main() {
    var op1 = creat("test_fj.txt", UInt32(O_RDONLY))
    var op2 = creat("test_fj.txt", UInt32(O_RDWR))
    var op3 = creat("test_fj.txt", UInt32(O_WRONLY))
    var op4 = creat("test_fj.txt", UInt32(O_APPEND))
    var op5 = creat("test_fj.txt", UInt32(O_CLOEXEC))
    var op6 = creat("test_fj.txt", UInt32(O_CREAT))
    var op7 = creat("test_fj.txt", UInt32(O_DIRECTORY))
    var op8 = creat("test_fj.txt", UInt32(O_DSYNC))
    var op9 = creat("test_fj.txt", UInt32(O_EXCL))
    var op10 = creat("test_fj.txt", UInt32(O_NOCTTY))
    var op11 = creat("test_fj.txt", UInt32(O_NOFOLLOW))
    var op12 = creat("test_fj.txt", UInt32(O_NONBLOCK))
    var op13 = creat("test_fj.txt", UInt32(O_SYNC))
    var op14 = creat("test_fj.txt", UInt32(O_TRUNC))
    var op15 = creat("test_fj.txt", UInt32(O_RSYNC))
    CaseRunner<Bool>().runCasesTrue(
        [
            (op1 is Int32),
            (op2 is Int32),
            (op3 is Int32),
            (op4 is Int32),
            (op5 is Int32),
            (op6 is Int32),
            (op7 is Int32),
            (op8 is Int32),
            (op9 is Int32),
            (op10 is Int32),
            (op11 is Int32),
            (op12 is Int32),
            (op13 is Int32),
            (op14 is Int32),
            (op15 is Int32)
        ],
        description: "创建各类权限文件，创建成功"
    )
    return 0
}
