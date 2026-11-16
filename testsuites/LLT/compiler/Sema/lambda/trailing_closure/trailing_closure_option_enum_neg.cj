// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %cmp_opt %typecheck %f 2>&1 | compare %f

enum E {
    | V((Int64) -> Int64)
}

func test(a: E) {}

main(): Int64 {
    test { x: Int64 => x }
    return 0
}

/* SCAN
error: mismatched types
  ==> trailing_closure_option_enum_neg.cj:16:10:
   | 
16 |     test { x: Int64 => x }
   |          ^^^^^^^^^^^^^^^^^ expected 'Enum-E', found '(Int64) -> Int64'
   | 

1 error generated, 1 error printed.
*/
