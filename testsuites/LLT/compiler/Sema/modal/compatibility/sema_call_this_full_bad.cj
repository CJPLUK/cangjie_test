// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_class.cj
// EXEC: %compiler %local %compile_lib_opt pkg_class.cj -o pkg_class.%middle
// EXEC-PIPE-1: %compiler %cmp_opt pkg_class.%middle %f -o %output %diag_json 2>&1 | compare %f

import pkg_class.*

main() {
    C().mFull()
}

// ASSERT: scan "DiagKind": "sema_local_api_disabled",
