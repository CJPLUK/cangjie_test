/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-IC-missing(组: IncrementalCache)
// 意图: 不兼容三元组+版本串抹除 → 增量路径同样拒绝,溯源落 cjc 'unknown'


// DEPENDENCE: pkg pkg.old.cj ../tools log_reject.txt
// EXEC: %cp pkg.old.cj pkg.cj
// EXEC: %compiler %cmp_opt pkg.cj %compile_lib_opt -o pkg.%middle
// EXEC: %compiler %incremental_compile %cmp_opt pkg.%middle %f -o %output
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version next-minor --clear-version-string
// EXEC-PIPE-1: %compiler %incremental_compile %cmp_opt pkg.%middle %f -o %output 2>&1 | compare %f
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan cjc 'unknown'
// (Linux)EXEC: cat .cached/*.log | compare log_reject.txt
// (Windows)EXEC: powershell Get-Content .cached/*.log | compare log_reject.txt

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
