// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1

abstract class I {
    public prop size: Int
}
class C <: I {
    public override prop size: Int @local? {
        get() {3}
    }
}

main() {
    let c:I = C()
    c.size
}

/* SCAN
error: 'override' property 'size' does not have an overridden property in its supertype
  ==> propoverride2.cj:13:5:
   | 
13 |     public override prop size: Int @local? {
   |     ^ 
   | 

error: class 'C' missing abstract modifier, otherwise abstract function or property should be implemented
  ==> propoverride2.cj:12:1:
   | 
12 |   class C <: I {
   |  _^
13 | |     public override prop size: Int @local? {
   | | ...
16 | | }
   | |_^
   | 
note: unimplemented abstract property 'size'
  ==> propoverride2.cj:10:5:
   | 
10 |     public prop size: Int
   |     ^^^^^^^^^^^^^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
