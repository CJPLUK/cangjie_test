/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj test_fj_notnull_0.txt test_fj_notnull_1.txt test_fj_notnull_2.txt test_fj_notnull_3.txt test_fj_notnull_4.txt test_fj_notnull_5.txt test_fj_notnull_6.txt test_fj_notnull_7.txt test_fj_notnull_8.txt test_fj_notnull_9.txt test_fj_notnull_10.txt test_fj_notnull_11.txt
// (!host_win) EXEC-PIPE: %compiler %cmp_opt caserunner.cj -o %output %f
// (!host_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args
// (!host_win) EXEC-PIPE: pwd
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-r\-\-\-\-\-\-\-\-'| %grep 'test_fj_notnull_0.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-w\-\-\-\-\-\-\-'| %grep 'test_fj_notnull_1.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-x\-\-\-\-\-\-'| %grep 'test_fj_notnull_2.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-rwx\-\-\-\-\-\-'| %grep 'test_fj_notnull_3.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-r\-\-\-\-\-'| %grep 'test_fj_notnull_4.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-\-w\-\-\-\-'| %grep 'test_fj_notnull_5.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-\-\-x\-\-\-'| %grep 'test_fj_notnull_6.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-rwx\-\-\-'| %grep 'test_fj_notnull_7.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-\-\-\-r\-\-'| %grep 'test_fj_notnull_8.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-\-\-\-\-w\-'| %grep 'test_fj_notnull_9.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-\-\-\-\-\-x'| %grep 'test_fj_notnull_10.txt'
// (!host_win) EXEC-PIPE: %ls -l |%grep '\-\-\-\-\-\-\-rwx'| %grep 'test_fj_notnull_11.txt'

import std.posix.*

main(): Int64 {
    var op0 = `open`("test_fj_notnull_0.txt", O_RDONLY)
    var op1 = `open`("test_fj_notnull_1.txt", O_RDONLY)
    var op2 = `open`("test_fj_notnull_2.txt", O_RDONLY)
    var op3 = `open`("test_fj_notnull_3.txt", O_RDONLY)
    var op4 = `open`("test_fj_notnull_4.txt", O_RDONLY)
    var op5 = `open`("test_fj_notnull_5.txt", O_RDONLY)
    var op6 = `open`("test_fj_notnull_6.txt", O_RDONLY)
    var op7 = `open`("test_fj_notnull_7.txt", O_RDONLY)
    var op8 = `open`("test_fj_notnull_8.txt", O_RDONLY)
    var op9 = `open`("test_fj_notnull_9.txt", O_RDONLY)
    var op10 = `open`("test_fj_notnull_10.txt", O_RDONLY)
    var op11 = `open`("test_fj_notnull_11.txt", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [
            (fchmod(op0, UInt32(S_IRUSR)), Int32(0)),
            (fchmod(op1, UInt32(S_IWUSR)), Int32(0)),
            (fchmod(op2, UInt32(S_IXUSR)), Int32(0)),
            (fchmod(op3, UInt32(S_IRWXU)), Int32(0)),
            (fchmod(op4, UInt32(S_IRGRP)), Int32(0)),
            (fchmod(op5, UInt32(S_IWGRP)), Int32(0)),
            (fchmod(op6, UInt32(S_IXGRP)), Int32(0)),
            (fchmod(op7, UInt32(S_IRWXG)), Int32(0)),
            (fchmod(op8, UInt32(S_IROTH)), Int32(0)),
            (fchmod(op9, UInt32(S_IWOTH)), Int32(0)),
            (fchmod(op10, UInt32(S_IXOTH)), Int32(0)),
            (fchmod(op11, UInt32(S_IRWXO)), Int32(0))
        ],
        description: "fchmod()函数入参文件存在且内容不为空"
    )
    return 0
}
