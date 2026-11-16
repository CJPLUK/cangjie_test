/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: test_fj_0.txt
// (!target_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args

import std.posix.*

main(): Int64 {
    var result1 = chown("test_fj_0.txt", UInt32(1013), UInt32(6667))
    var result = chown("test_fj_0.txt", UInt32(5454545), UInt32(5454545))
    if (result1 != Int32(0) && result1 != Int32(-1) && result != Int32(-1) && result != Int32(0)) {
        return 1
    }
    return 0
}
