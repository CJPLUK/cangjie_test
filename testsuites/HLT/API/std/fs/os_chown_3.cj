/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: test_fj_notnull.txt
// (!target_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args

import std.posix.*

main(): Int64 {
    var path = getcwd().toString()
    var filepath = path + "/test_fj_notnull.txt"
    var result = chown(filepath, UInt32(0), UInt32(0))
    if (result != Int32(0) && result != Int32(-1)) {
        return 1
    }
    return 0
}
