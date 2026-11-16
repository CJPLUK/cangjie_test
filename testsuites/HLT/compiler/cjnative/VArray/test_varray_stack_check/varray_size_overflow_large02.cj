/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// (!(target_android & target_aarch32 & O2)) ASSERT: scan The stacksize of default::main() exceeds cangjie max stacksize(2GB)
// (target_android & target_aarch32 & O2) ASSERT: scan The stacksize of 0_for_keeping_some_types exceeds cangjie max stacksize(2GB)

main(): Int64 {
    var varr: VArray<Int64, $6442450959> = VArray<Int64, $6442450959> {i => i + 1}
    if (varr.size == 6442450959) {
        return varr[0] - 1
    }
    return 1
}
