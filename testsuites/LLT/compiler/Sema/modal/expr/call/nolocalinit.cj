// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %cmp_opt -Woff all 2>&1

class Dog {}

main() {
    let d = Dog()@local!
}
/* SCAN
error: no matching constructor for call 'Dog'
  ==> nolocalinit.cj:12:13:
   | 
12 |     let d = Dog()@local!
   |             ^ 
   | 

1 error generated, 1 error printed.
*/
