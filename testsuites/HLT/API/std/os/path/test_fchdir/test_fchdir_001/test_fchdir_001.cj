/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_win) EXEC-PIPE: %compiler %cmp_opt %f -o %output
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_win) ASSERT: scan pass

import std.posix.*

foreign func printf(fmt: CString, ...): Int32

unsafe main() {
    var pwd1: String = "/"

    var fd = `open`(pwd1, O_RDONLY)
    var result: Int32 = fchdir(fd)

    var pwd2: String = getcwd()

    if ((result == 0) && (pwd2 == pwd1)) {
        print("pass")
    }

    close(fd)

    return 0
}
