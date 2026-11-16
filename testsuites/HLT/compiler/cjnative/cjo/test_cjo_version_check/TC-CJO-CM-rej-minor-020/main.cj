/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CM-rej-minor-020(组: CrossPackage)
// 意图: 比当前格式更新一个 minor 的版本被拒——旧读端不得静默消费新 minor 产物


// DEPENDENCE: pkg ../tools
// EXEC: %compiler %cmp_opt %pkg_opt pkg %compile_lib_opt -o pkg.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version next-minor --set-version-string v020probe
// EXEC-PIPE-1: %compiler %cmp_opt pkg.%middle %f -o %output 2>&1 | compare %f
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan but the current compiler is cjc
// ASSERT: scan v020probe

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
