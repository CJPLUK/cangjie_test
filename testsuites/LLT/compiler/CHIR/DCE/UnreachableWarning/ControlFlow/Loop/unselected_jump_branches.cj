// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Unselected source branches remain unreachable when their jump targets are shared and reachable.
// EXEC-PIPE-0: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

func singleBreak(flag: Bool): Unit {
    do {
        if (false) { break }
        println("work")
    } while (flag)
}

func singleContinue(flag: Bool): Unit {
    do {
        if (false) { continue }
        println("work")
    } while (flag)
}

main() {
    singleBreak(false)
    singleContinue(false)
}

/* SCAN-IN
warning: unreachable block in 'if' expression
  ==> unselected_jump_branches.cj:12:20:
   | 
12 |         if (false) { break }
   |                    ^^^^^^^^^ unreachable block in 'if' expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable block in 'if' expression
  ==> unselected_jump_branches.cj:19:20:
   | 
19 |         if (false) { continue }
   |                    ^^^^^^^^^^^^ unreachable block in 'if' expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
