/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: getPath.sh test_fj.txt
// (!target_win) EXEC-PIPE: chmod +x getPath.sh
// (!target_win) EXEC-PIPE: ./getPath.sh c
// (!target_win) EXEC-PIPE: %compiler %cmp_opt mypath.cj -o %output %f
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args
import std.posix.*

main() {
    var resulttrue1 = isChr(mypath)
    if (resulttrue1 != true) {
        return 1
    }
    var resultfalse1 = isChr("test_fj.txt")
    var resultfalse2 = isChr("./test_notexists")
    if (resultfalse1 != false || resultfalse2 != false) {
        return 2
    }
    return 0
}
