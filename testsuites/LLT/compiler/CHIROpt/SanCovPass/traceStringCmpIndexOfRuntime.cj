// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Check the runtime hook arguments in addition to the CHIR assertions in
// traceStringCmpIndexOf.cj. Only the String overload should call the hook.
// DEPENDENCE: sancov.h sancov.cpp
// EXEC: %clang++ -c -fPIC %stdc++_opt sancov.cpp -o sancov.o
// EXEC: %compiler %cmp_opt --sanitizer-coverage-trace-memcmp -Woff all sancov.o %f -o %output
// EXEC: %run %run_opt %output %run_args > runtime.out 2>&1
// EXEC: %cat runtime.out | compare %f

main(): Int64 {
    let str = "test"
    var res5: Int64 = str.indexOf("12") ?? -1
    var res1: Int64 = str.indexOf(12) ?? -1
    0
}

// ASSERT: scan-1 __cj_sanitizer_weak_hook_memcmp func
// ASSERT: regex-begin ^__cj_sanitizer_weak_hook_memcmp func$
// ASSERT: regex-next ^string1: test$
// ASSERT: regex-next ^string2: 12$
// ASSERT: regex-next ^size: 4$
