/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (!host_win) EXEC: %compiler %f %cmp_opt -o %output
// (!host_win) RUN-EXEC-PIPE-134: %run %run_opt %output %run_args 2>&1 | compare %f
// (!host_win & target_android) ASSERT: scan Aborted
// (!host_win & target_ohos) ASSERT: scan Signal 6 (core dumped)
// (!host_win & (target_ios | target_ios_simulator)) ASSERT: scan Abort trap
// (!host_win & target_mac) ASSERT: scan Abort trap
// (!host_win & target_linux) ASSERT: scan Aborted

foreign func abort(): Unit

main(): Unit {
    unsafe { abort() }
}
