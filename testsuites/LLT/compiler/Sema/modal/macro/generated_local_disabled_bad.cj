// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: generated_local.macro.cj
// EXEC: %compiler %local %cmp_macro generated_local.macro.cj
// EXEC-PIPE-1: %run_macro %compiler %f %diag_json 2>&1 | compare %f

import generated_local_macro.*
@M
func placeholder() {}
main() {}

// ASSERT: scan-1 "DiagKind": "parse_local_mode_disabled",
// ASSERT: scan "Errors": 1,
// ASSERT: scan "Content": "compile with the '--experimental --enable-local-mode' option to enable it",
// ASSERT: scan the error originates in the macro `M`
