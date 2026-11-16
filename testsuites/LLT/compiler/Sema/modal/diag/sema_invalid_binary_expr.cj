// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

class F {}
func foo(f: F @local!, g: Int64) {
    f + g
}
main() {}

/* SCAN
error: invalid binary operator '+' on type 'Class-F @local!' and 'Int64'
  ==> sema_invalid_binary_expr.cj:11:7:
   | 
11 |     f + g
   |       ^ 
   | 
   # note: you may want to implement 'operator func +(this @local!, right: Int64)' for type 'Class-F'

1 error generated, 1 error printed.
*/
