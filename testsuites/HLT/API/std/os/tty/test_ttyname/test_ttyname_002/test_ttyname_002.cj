/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_ios & !target_win) EXEC-PIPE: %compiler %cmp_opt %f -o %output
// (!target_ios & !target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_win) ASSERT: scan-not Exception

import std.posix.*

foreign func printf(fmt: CString, ...): Int32

unsafe main() {
    var fd = `open`("/dev/abc", O_RDONLY)
    ttyname(fd)
    close(fd)
    return 0
}
