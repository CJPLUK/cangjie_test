/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj
// (!target_win) EXEC-PIPE: %compiler %cmp_opt caserunner.cj -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args
// (!target_win) EXEC-PIPE: pwd
// (!target_win) EXEC-PIPE: ls -l | compare %f
// (!target_win) ASSERT: scan-not test_fj1.txt

import std.posix.*

main(): Int64 {
    var op1 = `open`("test_fj1.txt", O_RDONLY) //不存在的文件
    CaseRunner<Int32>().runCases(
        [
            (fchmod(op1, UInt32(S_IRUSR)), Int32(-1)),
            (fchmod(op1, UInt32(S_IWUSR)), Int32(-1)),
            (fchmod(op1, UInt32(S_IXUSR)), Int32(-1)),
            (fchmod(op1, UInt32(S_IRWXU)), Int32(-1)),
            (fchmod(op1, UInt32(S_IRGRP)), Int32(-1)),
            (fchmod(op1, UInt32(S_IWGRP)), Int32(-1)),
            (fchmod(op1, UInt32(S_IXGRP)), Int32(-1)),
            (fchmod(op1, UInt32(S_IRWXG)), Int32(-1)),
            (fchmod(op1, UInt32(S_IROTH)), Int32(-1)),
            (fchmod(op1, UInt32(S_IWOTH)), Int32(-1)),
            (fchmod(op1, UInt32(S_IXOTH)), Int32(-1)),
            (fchmod(op1, UInt32(S_IRWXO)), Int32(-1))
        ],
        description: "fchmod()函数入参文件是不存在的文件"
    )
    return 0
}
