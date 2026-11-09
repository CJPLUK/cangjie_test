// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1

class F {
    init() {}
    init(this @local!) {
        exclave {}
    }
}

func halfReturn(): F @local? {
    let b: F @local? = F()
    b
}

func fullReturn(): F @local! {
    F()
}

main() {}

/* SCAN
error: cannot return expression of internal @local? mode
  ==> sema_internal_local_return.cj:18:5:
   | 
18 |     b
   |     ^ 
   | 

error: cannot return expression of internal @local! mode
  ==> sema_internal_local_return.cj:22:5:
   | 
22 |     F()
   |     ^^^ 
   | 

2 errors generated, 2 errors printed.
*/
