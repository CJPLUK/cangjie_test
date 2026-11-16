// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// The first alternative matches, the second is skipped, and a false guard reaches the fallback.
// EXEC-PIPE-0: %compiler %cmp_opt -O2 %f -o %output 2>&1 | compare %f

enum E {
    A(Int64) | B(Int64)
}

main() {
    let value = E.A(1)
    let result = match (value) {
        case A(_) | B(1) where false => 10
        case _ => 20
    }
    println(result)
}

/* SCAN-IN
warning: unreachable pattern
  ==> enum_or_guard_false_fallback.cj:17:21:
   | 
17 |         case A(_) | B(1) where false => 10
   |                     ^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_or_guard_false_fallback.cj:17:32:
   | 
17 |         case A(_) | B(1) where false => 10
   |                                ^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
