// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %cmp_opt 2>&1 | compare %f
class D {
    var q: Int64
    init(this @ local!, w: Int64) {
        exclave {
            q = w
        }
    }
}

main(): Int64 {
    let d = D(9) @~local!
    return d.q
}
/* SCAN
error: expected ';' or '<NL>', found '!'
  ==> not_local_bang.cj:18:25:
   | 
18 |     let d = D(9) @~local!
   |                         ^ expected ';' or '<NL>' here
   | 

1 error generated, 1 error printed.
*/
