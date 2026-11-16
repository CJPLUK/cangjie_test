/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-IC-selfheal(组: IncrementalCache)
// 意图: 回退重建后增量编译恢复命中——失效只影响本次构建,不演变为永久全量退化


// DEPENDENCE: pkg pkg.old.cj ../tools log_selfheal_p1.txt log_selfheal_p2.txt diag_p1.txt diag_p2.txt
// EXEC: %cp pkg.old.cj pkg.cj
// EXEC: %compiler %cmp_opt pkg.cj %compile_lib_opt -o pkg.%middle
// EXEC: %compiler %incremental_compile %cmp_opt pkg.%middle %f -o %output
// 第一段:变异 (1,0,0) → 增量构建被拒,缓存日志落 frontend error 回退行
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version 1.0.0
// EXEC-PIPE-1: %compiler %incremental_compile %cmp_opt pkg.%middle %f -o %output 2>&1 | compare diag_p1.txt
// (Linux)EXEC: cat .cached/*.log | compare log_selfheal_p1.txt
// (Windows)EXEC: powershell Get-Content .cached/*.log | compare log_selfheal_p1.txt
// 第二段:恢复 (0,1,0) → 增量构建恢复命中(自愈),缓存日志无回退行
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version 0.1.0
// EXEC-PIPE-0: %compiler %incremental_compile %cmp_opt pkg.%middle %f -o %output 2>&1 | compare diag_p2.txt
// (Linux)EXEC: cat .cached/*.log | compare log_selfheal_p2.txt
// (Windows)EXEC: powershell Get-Content .cached/*.log | compare log_selfheal_p2.txt
// RUN-EXEC-0: %run %run_opt %output %run_args

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
