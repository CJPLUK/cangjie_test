/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CM-rej-minor-255(组: CrossPackage)
// 意图: minor × patch 双上界 (0,255,255) 仍被拒(minor 轴两点覆盖)


// DEPENDENCE: pkg ../tools
// EXEC: %compiler %cmp_opt %pkg_opt pkg %compile_lib_opt -o pkg.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version 0.255.255 --set-version-string v0255255probe
// EXEC-PIPE-1: %compiler %cmp_opt pkg.%middle %f -o %output 2>&1 | compare %f
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan but the current compiler is cjc
// ASSERT: scan v0255255probe

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
