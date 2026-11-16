/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CB-transitive(组: CrossPackage)
// 意图: 依赖闭包内含不兼容 cjo 时传递链不得静默放过(mid 编译即失败)


// DEPENDENCE: pkg pkg_mid ../tools
// EXEC: %compiler %cmp_opt %pkg_opt pkg %compile_lib_opt -o pkg.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version 1.0.0
// EXEC-PIPE-1: %compiler %cmp_opt %pkg_opt pkg_mid %compile_lib_opt -o mid.%middle 2>&1 | compare %f
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan pkg.cjo

import mid.*

main(): Int64 {
    if (midValue() == 42) {
        return 0
    }
    return 1
}
