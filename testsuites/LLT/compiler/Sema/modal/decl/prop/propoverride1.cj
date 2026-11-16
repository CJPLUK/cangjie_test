// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f
interface I {
    prop size: Int
}
class C <: I {
    public prop size: Int @local? {
        get() {3}
    }
}

main() {
    let c:I = C()
    c.size
}

/* SCAN
error: class 'C' missing abstract modifier, otherwise abstract function or property should be implemented
  ==> propoverride1.cj:11:1:
   | 
11 |   class C <: I {
   |  _^
12 | |     public prop size: Int @local? {
   | | ...
15 | | }
   | |_^
   | 
note: unimplemented interface property 'size'
 ==> propoverride1.cj:9:5:
  | 
9 |     prop size: Int
  |     ^^^^^^^^^^^^^^ 
  | 

1 error generated, 1 error printed.
*/
