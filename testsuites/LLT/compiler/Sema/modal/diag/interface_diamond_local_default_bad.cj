// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -Woff all 2>&1 | compare %f

interface I0 {
    func foo(this @local!): Unit {
        ()
    }
}

interface I1 <: I0 {}

interface I2 <: I0 {}

class C <: I1 & I2 {}

struct S <: I1 & I2 {}

main() {}
/* SCAN
error: interface function 'foo(this @local!): Unit' must be implemented in 'C'
  ==> interface_diamond_local_default_bad.cj:19:1:
   | 
19 | class C <: I1 & I2 {}
   | ^ 
   | 

error: interface function 'foo(this @local!): Unit' must be implemented in 'S'
  ==> interface_diamond_local_default_bad.cj:21:1:
   | 
21 | struct S <: I1 & I2 {}
   | ^ 
   | 

2 errors generated, 2 errors printed.
*/
