/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: generateRegexData.cj
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping --no-sub-pkg -Woff=all %f generateRegexData.cj -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run %run_opt %output %run_utest_opt %run_args
// TIMEOUT: 3600

main(): Int64 {
    benchmarkRegexAllCount("\\w", "EscapCharterW")
    return 0
}
