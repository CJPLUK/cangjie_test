// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %cmp_opt %typecheck %f 2>&1 | compare %f

func test<T>(a: ?T) {}

main(): Int64 {
    test { => 1 }
    return 0
}

/* SCAN
error: trailing lambda cannot be used for non function nor option of function type
  ==> trailing_closure_option_unbounded_generic_neg.cj:12:10:
   | 
12 |     test { => 1 }
   |          ^^^^^^^^ declaration type of parameter: 'Enum-Option<Generics-T>'
   | 
note: found candidate
 ==> trailing_closure_option_unbounded_generic_neg.cj:9:6:
  | 
9 | func test<T>(a: ?T) {}
  |      ^^^^ 
  | 

1 error generated, 1 error printed.
*/
