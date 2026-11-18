/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-BASICS-case-no-payload: a payload-less enum constructor pattern in
// `case Red =>` must not be treated as a variable binding by the case-binding
// scanner; the match arm must still reference the enum constructor and the
// contract compiles and runs (audit report 2 #29, non-clashing shape). Note:
// when a contract `variable` deliberately shares the constructor's name the
// over-report is kept by design (documented limitation).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

enum BasicsColor { Red | Green }

@Contract [variable v: Int64 = 0]
func basicsCaseNoPayload(c: BasicsColor): Int64 {
    match (c) {
        case Red => return 1
        case Green => return 2
    }
}

main() {
    if (basicsCaseNoPayload(BasicsColor.Red) != 1) {
        throw Exception("payload-less constructor pattern misbehaved")
    }
    println("ok")
}
