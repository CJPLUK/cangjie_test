/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CM-same(组: CrossPackage)
// 意图: 原生 (0,1,0) 未改,编译运行通过(不过度拒绝的 parity 基准)


// DEPENDENCE: pkg
// EXEC: %compiler %cmp_opt %pkg_opt pkg %compile_lib_opt -o pkg.%middle
// EXEC-PIPE-0: %compiler %cmp_opt pkg.%middle %f -o %output 2>&1 | compare %f
// ASSERT: scan-not is incompatible: compiled with cjc
// ASSERT: scan-not validation of
// RUN-EXEC-0: %run %run_opt %output %run_args

import pkg.*

main(): Int64 {
    if (depValue() == 42) {
        return 0
    }
    return 1
}
