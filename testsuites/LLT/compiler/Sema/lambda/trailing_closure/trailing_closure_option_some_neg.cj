// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %cmp_opt %typecheck %f 2>&1 | compare %f

main(): Int64 {
    let x = Some { => 1 }
    return 0
}

/* SCAN
error: trailing lambda cannot be used for non function nor option of function type
  ==> trailing_closure_option_some_neg.cj:10:18:
   | 
10 |     let x = Some { => 1 }
   |                  ^^^^^^^^ declaration type of parameter: 'Generics-T'
   | 
note: found candidate
  ==> (package std.core)option.cj:21:5:

1 error generated, 1 error printed.
*/
