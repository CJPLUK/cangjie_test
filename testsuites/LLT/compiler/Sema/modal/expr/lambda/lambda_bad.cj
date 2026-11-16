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
    init(this @local?) { exclave { } }
}
func f() {
    let x: F@local? = F()
    let h:(()->Unit) = {
        => println(x.a)
    }

    let y: F@local! = F()
    @local! func m() {
        println(y.a)
    }
}

main() {
    f()
}

/* SCAN
error: cannot capture @local? variable 'x' in @~local lambda
  ==> lambda_bad.cj:18:20:
   | 
18 |         => println(x.a)
   |                    ^ 
   | 

error: cannot define a local function with @local! function type
  ==> lambda_bad.cj:22:5:
   | 
22 |       @local! func m() {
   |  _____^
23 | |         println(y.a)
24 | |     }
   | |_____^
   | 

2 errors generated, 2 errors printed.
*/