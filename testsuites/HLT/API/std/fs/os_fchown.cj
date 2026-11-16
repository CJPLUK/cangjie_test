/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: test_fj.txt test_fj_notnull.txt
// (!target_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args
import std.posix.*

main(): Int64 {
    var op = `open`("test_fj.txt", O_RDONLY)
    var op1 = `open`("", O_RDONLY)
    var op2 = `open`("test_fj_notnull.txt", O_RDONLY)
    var result: Array<Int32> = [fchown(op, UInt32(1), UInt32(2)), fchown(op, UInt32(0), UInt32(0)),
        fchown(op1, UInt32(1), UInt32(2)), fchown(op1, UInt32(0), UInt32(0)), fchown(op2, UInt32(1), UInt32(2)),
        fchown(op2, UInt32(0), UInt32(0))]
    for (i in result) {
        if (i != Int32(0) && i != Int32(-1)) {
            return 1
        }
    }
    return 0
}
