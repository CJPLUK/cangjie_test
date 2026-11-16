/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj test_fj.txt test_fj_notnull.txt
// (!target_win) EXEC: %compiler %cmp_opt caserunner.cj -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_win) ASSERT: scan-not AssertionError
import std.posix.*

main(): Int64 {
    var op = `open`("test_fj.txt", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [
            (fchmodat(op, "test_fj.txt", UInt32(S_IRUSR), Int32(S_IRWXO)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IWUSR), Int32(S_IWUSR)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IXUSR), Int32(S_IXUSR)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IRWXU), Int32(S_IRWXU)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IRGRP), Int32(S_IRGRP)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IWGRP), Int32(S_IWGRP)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IXGRP), Int32(S_IXGRP)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IRWXG), Int32(S_IRWXG)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IROTH), Int32(S_IROTH)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IWOTH), Int32(S_IWOTH)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IXOTH), Int32(S_IXOTH)), Int32(-1)),
            (fchmodat(op, "test_fj.txt", UInt32(S_IRWXO), Int32(S_IRWXO)), Int32(-1))
        ],
        description: "test case 1"
    )
    var op1 = `open`("", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [
            (fchmodat(op1, "test_fj.txt", UInt32(S_IRUSR), Int32(S_IRWXO)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IWUSR), Int32(S_IWUSR)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IXUSR), Int32(S_IXUSR)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IRWXU), Int32(S_IRWXU)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IRGRP), Int32(S_IRGRP)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IWGRP), Int32(S_IWGRP)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IXGRP), Int32(S_IXGRP)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IRWXG), Int32(S_IRWXG)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IROTH), Int32(S_IROTH)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IWOTH), Int32(S_IWOTH)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IXOTH), Int32(S_IXOTH)), Int32(-1)),
            (fchmodat(op1, "test_fj.txt", UInt32(S_IRWXO), Int32(S_IRWXO)), Int32(-1))
        ],
        description: "test case 2"
    )
    var op2 = `open`("", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [
            (fchmodat(op2, "", UInt32(S_IRUSR), Int32(S_IRWXO)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IWUSR), Int32(S_IWUSR)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IXUSR), Int32(S_IXUSR)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IRWXU), Int32(S_IRWXU)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IRGRP), Int32(S_IRGRP)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IWGRP), Int32(S_IWGRP)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IXGRP), Int32(S_IXGRP)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IRWXG), Int32(S_IRWXG)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IROTH), Int32(S_IROTH)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IWOTH), Int32(S_IWOTH)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IXOTH), Int32(S_IXOTH)), Int32(-1)),
            (fchmodat(op2, "", UInt32(S_IRWXO), Int32(S_IRWXO)), Int32(-1))
        ],
        description: "test case 3"
    )
    var op3 = `open`("test_fj_notnull.txt", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [
            (fchmodat(op3, "", UInt32(S_IRUSR), Int32(S_IRWXO)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IWUSR), Int32(S_IWUSR)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IXUSR), Int32(S_IXUSR)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IRWXU), Int32(S_IRWXU)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IRGRP), Int32(S_IRGRP)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IWGRP), Int32(S_IWGRP)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IXGRP), Int32(S_IXGRP)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IRWXG), Int32(S_IRWXG)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IROTH), Int32(S_IROTH)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IWOTH), Int32(S_IWOTH)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IXOTH), Int32(S_IXOTH)), Int32(-1)),
            (fchmodat(op3, "", UInt32(S_IRWXO), Int32(S_IRWXO)), Int32(-1))
        ],
        description: "test case 4"
    )
    var op4 = `open`("", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IRUSR), Int32(S_IRWXO)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IWUSR), Int32(S_IWUSR)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IXUSR), Int32(S_IXUSR)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IRWXU), Int32(S_IRWXU)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IRGRP), Int32(S_IRGRP)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IWGRP), Int32(S_IWGRP)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IXGRP), Int32(S_IXGRP)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IRWXG), Int32(S_IRWXG)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IROTH), Int32(S_IROTH)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IWOTH), Int32(S_IWOTH)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IXOTH), Int32(S_IXOTH)), Int32(-1)),
            (fchmodat(op4, "test_fj_notnull.txt", UInt32(S_IRWXO), Int32(S_IRWXO)), Int32(-1))
        ],
        description: "test case 5"
    )
    return 0
}
