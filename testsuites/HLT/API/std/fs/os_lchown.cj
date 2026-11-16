/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj test_fj.txt test_fj_notnull.txt
// (!target_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args

import std.posix.*

main(): Int64 {
    var result1 = lchown("test_fj.txt", UInt32(10133333), UInt32(1133333))
    var result2 = lchown("test_fj_notnull.txt", UInt32(101333333), UInt32(1133333))
    var result3 = lchown("test_fj1.txt", UInt32(1003337), UInt32(13333313))
    var result4 = lchown("", UInt32(1033307), UInt32(1133333))
    if (result1 != Int32(0) && result1 != Int32(-1) && result2 != Int32(0) && result2 != Int32(-1) && result3 != Int32(0) &&
        result3 != Int32(-1) && result4 != Int32(0) && result4 != Int32(-1)) {
        return 1
    }
    return 0
}
