// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A false guard rejects its case, so the fallback remains reachable.
// EXEC-PIPE-0: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

main() {
    match (3) {
        case 3 where false => println("g")
        case _ => println("b")
    }
}

/* SCAN-IN
warning: unreachable pattern
  ==> match_false_guard_fallback.cj:12:22:
   | 
12 |         case 3 where false => println("g")
   |                      ^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
