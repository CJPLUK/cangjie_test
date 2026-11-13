// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %cmp_opt %typecheck %f 2>&1 | compare %f

func test(a: Option<Int64>) {}

main(): Int64 {
    test {=> 1}
    return 0
}

/* SCAN
error: mismatched types
  ==> trailing_closure_option_type_mismatch.cj:12:10:
   | 
12 |     test {=> 1}
   |          ^^^^^^ expected 'Enum-Option<Int64>', found '() -> Int64'
   | 

1 error generated, 1 error printed.
*/
