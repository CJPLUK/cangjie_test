/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CM-rej-major-100(组: CrossPackage)
// 意图: major 更新 (1,0,0) 编译失败;诊断含双端 cjc 版本与产物 version 串


// DEPENDENCE: pkg ../tools
// EXEC: %compiler %cmp_opt %pkg_opt pkg %compile_lib_opt -o pkg.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo pkg.cjo --set-cjo-version 1.0.0 --set-version-string v100probe
// EXEC-PIPE-1: %compiler %cmp_opt pkg.%middle %f -o %output 2>&1 | compare %f
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan but the current compiler is cjc
// ASSERT: scan v100probe

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
