// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

class C {
    exclave init(this @local!) {}
    var p = 1
}
func foo() {
    let b: C@local? = C()
    spawn {
        println(b.p)
    }
}
main() {
    foo()
    0
}
/* SCAN
error: cannot access local variable b of 'Class-C @local?' type defined outside spawn
  ==> spawn_capture_bad.cj:16:17:
   | 
14 |     let b: C@local? = C()
   |     ~~~~~~~~~~~~~~~~~~~~~ variable declared here
15 |     spawn {
16 |         println(b.p)
   |                 ^ 
   | 

1 error generated, 1 error printed.
*/