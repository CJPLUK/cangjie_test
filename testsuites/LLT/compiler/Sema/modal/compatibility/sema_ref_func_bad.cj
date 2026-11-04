// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_func.cj
// EXEC: %compiler %local %compile_lib_opt pkg_func.cj -o pkg_func.%middle
// EXEC-PIPE-1: %compiler %cmp_opt pkg_func.%middle %f -o %output %diag_json 2>&1 | compare %f

import pkg_func.*

main() {
    let g = retObjFull
}

// ASSERT: scan "DiagKind": "sema_local_api_disabled",
