// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-level=1 --sanitizer-coverage-stack-depth -Woff all %f -o sancov-stack.out 2>&1 | compare %f --assert_flag=ASSERT_DIAGNOSTIC
// EXEC: %python pick_defination.py sancov-stack_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-level=0 --sanitizer-coverage-inline-bool-flag -Woff all %f -o sancov-bool.out 2>&1 | compare %f --assert_flag=ASSERT_DIAGNOSTIC
// EXEC: %python pick_defination.py sancov-bool_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

main() {
    0
}

// ASSERT_DIAGNOSTIC: scan-1 '--sanitizer-coverage-level' is illegal here

// ASSERT: scan-not @__sanitizer_cov_trace_
// ASSERT: scan-not @__cj_sancov_
// ASSERT: scan-not sancov$_
