// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %cmp_opt 2>&1 | compare %f

let a: Int @~local = 1
let b: Int @local? = 2
let c: Int @local! = 3

main() {}

/* SCAN
error: expected data type here, got modal type 'Int64 @local?'
  ==> global_bad.cj:10:8:
   | 
10 | let b: Int @local? = 2
   |        ^^^^^^^^^^^ 
   | 

error: expected data type here, got modal type 'Int64 @local!'
  ==> global_bad.cj:11:8:
   | 
11 | let c: Int @local! = 3
   |        ^^^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
