// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_nested_exports.cj
// EXEC: %compiler %local %compile_lib_opt pkg_nested_exports.cj -o pkg_nested_exports.%middle
// EXEC-PIPE-1: %compiler pkg_nested_exports.%middle %f -o %output %diag_json 2>&1 | compare %f

import pkg_nested_exports.*
main() {
    let f = makeFull()
    let h = makeHalf()
}

// ASSERT: scan-2 "DiagKind": "sema_local_api_disabled",
// ASSERT: scan "Errors": 2,
