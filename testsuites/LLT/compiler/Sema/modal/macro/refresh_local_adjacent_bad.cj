// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: identity.macro.cj
// EXEC: %compiler %local %cmp_macro identity.macro.cj
// EXEC-PIPE-1: %run_macro %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

import identity_macro.*

@Identity
func badBang() {
    let x: Int64 @local ! = 0
}

@Identity
func badTilde() {
    let y: Int64 @~ local = 0
}

// ASSERT: scan-2 "DiagKind": "parse_expected_character"
