/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Case: TC-CJO-BC-legacy-upstream (group: CrossPackage)
// Intent: both upstream cjo archives demoted on copies to legacy triples
//   ((0,0,0) / (0,0,1)), then moved back; the downstream driver must compile
//   silently and run.
// Note: keep this file ASCII-only.


// DEPENDENCE: pkg_l1 pkg_l2 ../tools diag_ok.txt
// EXEC: %compiler %cmp_opt %pkg_opt pkg_l1 %compile_lib_opt -o l1.%middle
// EXEC: %compiler %cmp_opt %pkg_opt pkg_l2 %compile_lib_opt -o l2.%middle
// EXEC: %cp l1.cjo l1_mut.cjo
// EXEC: %cp l2.cjo l2_mut.cjo
// EXEC: %python tools/cjo_mutate.py --patch-cjo l1_mut.cjo --set-cjo-version 0.0.0
// EXEC: %python tools/cjo_mutate.py --patch-cjo l2_mut.cjo --set-cjo-version 0.0.1
// EXEC: %cp l1_mut.cjo l1.cjo
// EXEC: %cp l2_mut.cjo l2.cjo
// EXEC-PIPE-0: %compiler %cmp_opt l1.%middle l2.%middle %f -o %output 2>&1 | compare diag_ok.txt
// ASSERT: scan-not is incompatible: compiled with cjc
// ASSERT: scan-not validation of
// RUN-EXEC-0: %run %run_opt %output %run_args

import l1.*
import l2.*

main(): Int64 {
    if (l1Value() + l2Value() == 30) {
        return 0
    }
    return 1
}
