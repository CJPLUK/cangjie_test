// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-stack-depth -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

func f1(t1: Int8, t2: Int16, t4: Int32, t8: Int64): Int64 {
    if (t1 != 0) {
        if (t2 != 0) {
            if (t4 != 0) {
                if (t8 != 0) {
                    return Int64(t1) & Int64(t2) & Int64(t4) & t8
                }
            }
        }
    }
    return 1
}

main() {
    f1(1, 1, 1, 1)
    0
}

// ASSERT: regex-2 = Apply\(@__cj_sancov_update_stack_depth[,)]
// ASSERT: regex-begin Func @_CN7default2f1
// ASSERT: regex-after ^Block #0:
// ASSERT: regex-next ^\s*%\d+: Unit = Apply\(@__cj_sancov_update_stack_depth\)
// ASSERT: regex-begin Func @_CN7default6<main>
// ASSERT: regex-after ^Block #0:
// ASSERT: regex-next ^\s*%\d+: Unit = Apply\(@__cj_sancov_update_stack_depth\)
