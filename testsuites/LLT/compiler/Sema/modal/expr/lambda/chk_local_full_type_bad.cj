// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output 2>&1 | compare %f

// Chk: lambda cannot be annotated (())->Unit)@local!.

func f() {
    let h:(()->Unit)@local! = { => println(0) }
}

main() {
    f()
}

/* SCAN
error: cannot define a lambda with @local! function type
  ==> chk_local_full_type_bad.cj:12:31:
   | 
12 |     let h:(()->Unit)@local! = { => println(0) }
   |                               ^^^^^^^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
