/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!host_win) EXEC-PIPE: %touch test_fj_0.txt
// (!host_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!host_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args

import std.posix.*

main(): Int64 {
    var result = chown("test_fj_0.txt", UInt32(0), UInt32(0))
    if (result != Int32(0) && result != Int32(-1)) {
        println("result=" + result.toString())
        return 1
    }
    return 0
}
