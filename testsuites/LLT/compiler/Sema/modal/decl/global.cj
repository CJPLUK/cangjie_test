// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1
let a: Int64 @local! = 38

let b = Array<Int64>() @local!

main() {}

/* SCAN
error: expected data type here, got modal type 'Int64 @local!'
 ==> global.cj:8:8:
  | 
8 | let a: Int64 @local! = 38
  |        ^^^^^^^^^^^^^ 
  | 

error: expected data type here, got modal type 'Struct-Array<Int64> @local!'
  ==> global.cj:10:1:
   | 
10 | let b = Array<Int64>() @local!
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/