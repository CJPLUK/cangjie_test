// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %cmp_opt %f 2>&1

class C {
    var v = 1
    init() {}
    init(this @local?) { exclave {} }
}
class D {
    var c: C
    init() { c = C() }
    init(this @local?) { exclave { c = C() } }
}
class E {
    var d: D
    init() { d = D() }
    exclave init(this @local?, value: D@local?) {
        value.c = C()
        d = value
        this.d = value
    }

    ~init(this @local?) {
        d = D()
        d.c = C()
    }
}

main() {}
/* SCAN
error: cannot assign to member of @local? value of non copy type outside its constructor and finalizer
  ==> assign_member_non_this_good.cj:23:9:
   | 
23 |         value.c = C()
   |         ^^^^^^^^^^^^^ 
   | 

error: cannot assign to member of @local? value of non copy type outside its constructor and finalizer
  ==> assign_member_non_this_good.cj:30:9:
   | 
30 |         d.c = C()
   |         ^^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
