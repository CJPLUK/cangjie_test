/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: segfault.c
// (!host_win) EXEC: %clang -c %clang_opt segfault.c -o lib%n.c.cfile.%cffi_suffix
// (!host_win) EXEC: %compiler -L. -l%n.c.cfile %f %cmp_opt -o %output
// (!host_win) RUN-EXEC-PIPE-139: %run %run_opt %output %run_args 2>&1 | compare %f
// (!host_win & target_android) ASSERT: scan Segmentation fault
// (!host_win & target_ohos) ASSERT: scan Signal 11 (core dumped)
// (!host_win & (target_ios | target_ios_simulator)) ASSERT: scan Segmentation fault
// (!host_win & target_mac) ASSERT: scan Segmentation fault
// (!host_win & target_linux) ASSERT: scan Segmentation fault

foreign func foo(): Unit

main(): Unit {
    unsafe { foo() }
}
