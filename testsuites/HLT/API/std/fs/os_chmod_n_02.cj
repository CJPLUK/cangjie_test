/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj
// (!target_win) EXEC: %compiler %cmp_opt caserunner.cj -o %output %f
// (!target_win) RUN-EXEC: %run %run_opt %output %run_args
// (!target_win) RUN-EXEC-PIPE: %target_ls -l | compare %f
// (!target_win) ASSERT: scan-not test_fj1.txt

import std.posix.*

main(): Int64 {
    CaseRunner<Int32>().runCases(
        [
            (chmod("test_fj1.txt", UInt32(S_IRUSR)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IWUSR)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IXUSR)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IRWXU)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IRGRP)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IWGRP)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IXGRP)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IRWXG)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IROTH)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IWOTH)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IXOTH)), Int32(-1)),
            (chmod("test_fj1.txt", UInt32(S_IRWXO)), Int32(-1))
        ],
        description: "chmod()函数，入参是文件不存在"
    )
    return 0
}
