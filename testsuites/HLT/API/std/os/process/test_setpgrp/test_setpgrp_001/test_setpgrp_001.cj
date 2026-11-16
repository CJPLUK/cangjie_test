/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_ios & !target_win) EXEC: %compiler %cmp_opt %f -o %output
// (!target_ios & !target_win) RUN-EXEC: %run %run_opt %output %run_args | compare %f
// (!target_win) ASSERT: scan pass

import std.posix.*

main() {
    var result1: Int32 = setpgrp()
    if (result1 != -1) {
        var result2: Int32 = getpgrp()
        if (result2 != -1) {
            print("pass\n")
        }
    }
    return 0
}
