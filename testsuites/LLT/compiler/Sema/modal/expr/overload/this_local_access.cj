// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1
class C {
    exclave init(this @local!) {}
    func foo(this @local!) {1}
    func foo(this @local?) {0}
}

main() {
    let c = C()@local!
    let d = c.foo
    d()
}

/* SCAN
error: cannot capture @local! variable 'foo' in member function reference
  ==> this_local_access.cj:15:13:
   | 
15 |     let d = c.foo
   |             ^^^^^ 
   | 

1 error generated, 1 error printed.
*/
