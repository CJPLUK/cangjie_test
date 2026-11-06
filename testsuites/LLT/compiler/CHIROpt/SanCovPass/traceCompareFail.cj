// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-compares -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

foreign func ShowSwitchArray(): Unit

func f1(t1: Float16, t2: Float32): Int64 {
    if (t1 != 0.0) {
        if (t2 != 0.0) {
            return 0
        }
    }
    return 1
}

main() {
    f1(1.0, 1.0)
    0
}

// ASSERT: scan-2 = NotEqual(
// ASSERT: regex-begin Func @_CN7default2f1
// ASSERT: regex-after \[t1\]: Float16
// ASSERT: regex-after \[t2\]: Float32
// ASSERT: scan-not = Apply(@__sanitizer_cov_trace_
