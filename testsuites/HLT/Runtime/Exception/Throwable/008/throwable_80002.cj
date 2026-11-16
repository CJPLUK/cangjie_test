/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: use_80002.cj
// EXEC: %compiler %cmp_opt %f %compile_lib_opt -o define.%middle
// EXEC: %compiler %cmp_opt use_80002.cj define.%middle -o %output
// RUN-EXEC-PIPE-1: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan An exception has occurred:
// (!O2) ASSERT: scan at define::A::init()
// ASSERT: scan at define::a

package define

class A <: Exception {}

public var a: Int64 = if (true) {
    throw A();
    1
} else {
    1
}
