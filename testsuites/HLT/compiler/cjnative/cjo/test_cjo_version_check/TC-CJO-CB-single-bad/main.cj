/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CB-single-bad(组: CrossPackage)
// 意图: b 不兼容时编译失败且诊断仅指向 b;替换为兼容版本后重编成功、运行通过


// DEPENDENCE: pkg_a pkg_c pkg_b ../tools diag_reject.txt diag_ok.txt
// EXEC: %compiler %cmp_opt %pkg_opt pkg_a %compile_lib_opt -o a.%middle
// EXEC: %compiler %cmp_opt %pkg_opt pkg_c %compile_lib_opt -o c.%middle
// EXEC: %compiler %cmp_opt %pkg_opt pkg_b %compile_lib_opt -o b.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo b.cjo --set-cjo-version next-minor
// EXEC-PIPE-1: %compiler %cmp_opt a.%middle b.%middle c.%middle %f -o %output 2>&1 | compare diag_reject.txt
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan b.cjo
// EXEC: %python tools/cjo_mutate.py --patch-cjo b.cjo --set-cjo-version 0.1.0
// EXEC-PIPE-0: %compiler %cmp_opt a.%middle b.%middle c.%middle %f -o %output 2>&1 | compare diag_ok.txt
// ASSERT: scan-not is incompatible: compiled with cjc
// RUN-EXEC-0: %run %run_opt %output %run_args

import a.*
import b.*
import c.*

main(): Int64 {
    if (aValue() + bValue() + cValue() == 126) {
        return 0
    }
    return 1
}
