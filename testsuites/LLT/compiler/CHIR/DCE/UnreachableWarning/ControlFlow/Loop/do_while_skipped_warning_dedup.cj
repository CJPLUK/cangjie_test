// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A skipped do-while warning must not suppress an if warning for the same exit block.
// EXEC-PIPE-0: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

func probe(flag: Bool): Unit {
    do {
        if (false) { break }
        if (flag) { continue }
        println("work")
    } while (true)
}

main() { probe(false) }

/* SCAN-IN
warning: unreachable block in 'if' expression
  ==> do_while_skipped_warning_dedup.cj:12:20:
   | 
12 |         if (false) { break }
   |                    ^^^^^^^^^ unreachable block in 'if' expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
