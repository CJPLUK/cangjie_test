/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Case: TC-CJO-CB-isolation (group: CrossPackage)
// Intent: after the b.cjo version reject, a second compile with a+c only
//   succeeds and runs - a version failure must not poison loaded-package
//   state or the cache.
// Note: keep this file ASCII-only (framework re-opens it with locale
//   encoding once a SEPARATE-FILE directive is present).


// DEPENDENCE: pkg_a pkg_c pkg_b ../tools diag_reject.txt diag_ok.txt
// EXEC: %compiler %cmp_opt %pkg_opt pkg_a %compile_lib_opt -o a.%middle
// EXEC: %compiler %cmp_opt %pkg_opt pkg_c %compile_lib_opt -o c.%middle
// EXEC: %compiler %cmp_opt %pkg_opt pkg_b %compile_lib_opt -o b.%middle
// EXEC: %python tools/cjo_mutate.py --patch-cjo b.cjo --set-cjo-version 1.0.0
// EXEC-PIPE-1: %compiler %cmp_opt a.%middle b.%middle c.%middle main.cj -o %output 2>&1 | compare diag_reject.txt
// ASSERT: scan is incompatible: compiled with cjc
// ASSERT: scan b.cjo
// EXEC: %python tools/cjo_mutate.py --patch-cjo b.cjo --set-cjo-version 0.1.0
// EXEC-0: %compiler %cmp_opt a.%middle c.%middle main_iso.cj -o iso.%output 2>&1 | compare diag_ok.txt
// ASSERT: scan-not is incompatible: compiled with cjc
// RUN-EXEC-0: %run %run_opt iso.%output %run_args

// SEPARATE-FILE: main_iso.cj
import a.*
import c.*

main(): Int64 {
    if (aValue() + cValue() == 4) {
        return 0
    }
    return 1
}

// SEPARATE-FILE: main.cj
import a.*
import b.*
import c.*

main(): Int64 {
    if (aValue() + bValue() + cValue() == 126) {
        return 0
    }
    return 1
}
