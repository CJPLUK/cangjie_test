/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-VP-truncated(组: CrossPackage)
// 意图: 截断 → Verifier 结构拒绝(先于版本层,版本字段可能仍可读)


// DEPENDENCE: pkg ../tools
// EXEC: %compiler %cmp_opt %pkg_opt pkg %compile_lib_opt -o pkg.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --truncate 500
// EXEC-PIPE-1: %compiler %cmp_opt pkg.%middle %f -o %output 2>&1 | compare %f
// ASSERT: scan validation of
// ASSERT: scan failed, please confirm it was created by compiler whose version is
// ASSERT: scan-not is incompatible: compiled with cjc

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
