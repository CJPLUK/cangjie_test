// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output 2>&1 | compare %f

class F {
    var a = 1
    init() {}
    init(this @local!) { exclave { } }
}

func f() {
    let y: F@local! = F()
    let h = { => println(y.a) }
}

main() {
    f()
}

/* SCAN
error: cannot capture @local! variable 'y' in @~local lambda
  ==> syn_capture_local_full_bad.cj:17:26:
   | 
17 |     let h = { => println(y.a) }
   |                          ^ 
   | 

1 error generated, 1 error printed.
*/
