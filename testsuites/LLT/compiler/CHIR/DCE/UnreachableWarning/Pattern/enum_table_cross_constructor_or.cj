// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Payload constants are not propagated yet; constructor fragments are still grouped across enum table branches.
// EXEC-PIPE-0: %compiler %cmp_opt -O2 %f -o %output 2>&1 | compare %f

enum Mode {
    | Left(Int64)
    | Right(Int64)
    | Done
}

main() {
    const selected = Mode.Left(1)
    let selectedResult = match (selected) {
        case Left(1) | Right(1) => 0
        case _ => 1
    }
    println(selectedResult)

    const done = Mode.Done
    let doneResult = match (done) {
        case Left(1) | Right(1) => 0
        case Left(2) | Right(2) => 1
        case _ => 2
    }
    println(doneResult)
}

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_cross_constructor_or.cj:19:24:
   | 
19 |         case Left(1) | Right(1) => 0
   |                        ^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_cross_constructor_or.cj:26:14:
   | 
26 |         case Left(1) | Right(1) => 0
   |              ^^^^^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_cross_constructor_or.cj:27:14:
   | 
27 |         case Left(2) | Right(2) => 1
   |              ^^^^^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
