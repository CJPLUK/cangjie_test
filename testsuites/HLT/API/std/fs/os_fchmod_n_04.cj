/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args
import std.posix.*

main(): Int64 {
    var op3 = `open`("", O_RDONLY) //空路径
    var result1 = fchmod(op3, UInt32(S_IRUSR))
    var result2 = fchmod(op3, UInt32(S_IWUSR))
    var result3 = fchmod(op3, UInt32(S_IXUSR))
    var result4 = fchmod(op3, UInt32(S_IRWXU))
    var result5 = fchmod(op3, UInt32(S_IRGRP))
    var result6 = fchmod(op3, UInt32(S_IWGRP))
    var result7 = fchmod(op3, UInt32(S_IXGRP))
    var result8 = fchmod(op3, UInt32(S_IRWXG))
    var result9 = fchmod(op3, UInt32(S_IROTH))
    var result10 = fchmod(op3, UInt32(S_IWOTH))
    var result11 = fchmod(op3, UInt32(S_IRWXO))
    if (result1 != Int32(0) && result1 != Int32(-1)) {
        return 1
    }
    if (result2 != Int32(0) && result2 != Int32(-1)) {
        return 2
    }
    if (result3 != Int32(0) && result3 != Int32(-1)) {
        return 3
    }
    if (result4 != Int32(0) && result4 != Int32(-1)) {
        return 4
    }
    if (result5 != Int32(0) && result5 != Int32(-1)) {
        return 5
    }
    if (result6 != Int32(0) && result6 != Int32(-1)) {
        return 6
    }
    if (result7 != Int32(0) && result7 != Int32(-1)) {
        return 7
    }
    if (result8 != Int32(0) && result8 != Int32(-1)) {
        return 8
    }
    if (result9 != Int32(0) && result9 != Int32(-1)) {
        return 9
    }
    if (result10 != Int32(0) && result10 != Int32(-1)) {
        return 10
    }
    if (result11 != Int32(0) && result11 != Int32(-1)) {
        return 11
    }
    return 0
}
