// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: 19_macroAstRoundTrip_define.cj
// EXEC: %compiler %cmp_macro 19_macroAstRoundTrip_define.cj
// EXEC-PIPE-1: %run_macro %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'Extern' type
// ASSERT: scan use 'as' for ordinary type conversions

import forced_cast_macro.*

@DeclRoundTrip
func invalidThroughMacro(arg: Int64): Int64 {
    (Int64)(arg)
}

main() {}
