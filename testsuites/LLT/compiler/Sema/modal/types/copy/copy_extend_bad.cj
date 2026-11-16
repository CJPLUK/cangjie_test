// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

struct S {
    let r = "hello"
}
extend S <: Copyable {}
main() {}

/* SCAN
error: cannot declare field 'r' of non copy type 'Struct-String' in copy type 'S'
  ==> copy_extend_bad.cj:10:5:
   | 
10 |     let r = "hello"
   |     ^^^^^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
