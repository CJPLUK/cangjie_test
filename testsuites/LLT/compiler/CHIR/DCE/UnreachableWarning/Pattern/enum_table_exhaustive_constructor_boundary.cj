// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify exhaustive enum tables preserve constructor boundaries and completion.
// EXEC-PIPE-0: %compiler %cmp_opt -O2 %f -o %output 2>&1 | compare %f

enum State {
    | Left(Int64, Bool)
    | Right(Int64, Bool)
}

func selectRight(flag: Bool): Int64 {
    let state = State.Right(0, flag)
    return match (state) {
        case Left(_, true) => 0
        case Left(_, false) => 1
        case Right(_, true) => 2
        case Right(_, false) => 3
    }
}

func selectLeft(flag: Bool): Int64 {
    let state = State.Left(0, flag)
    return match (state) {
        case Left(_, true) => 0
        case Left(_, false) => 1
        case Right(_, true) => 2
        case Right(_, false) => 3
    }
}

main() {
    println(selectRight(true))
    println(selectLeft(false))
    endTrivial(Plain.A)
    endPayload(State.Right(0, true))
}

enum Plain { A | B }

func endTrivial(state: Plain): Unit {
    match (state) {
        case A => return
        case B => return
    }
    println("dead after trivial table")
}

func endPayload(state: State): Unit {
    match (state) {
        case Left(_, true) => return
        case Left(_, false) => return
        case Right(_, true) => return
        case Right(_, false) => return
    }
    println("dead after payload table")
}

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_exhaustive_constructor_boundary.cj:18:14:
   | 
18 |         case Left(_, true) => 0
   |              ^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_exhaustive_constructor_boundary.cj:19:14:
   | 
19 |         case Left(_, false) => 1
   |              ^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_exhaustive_constructor_boundary.cj:30:14:
   | 
30 |         case Right(_, true) => 2
   |              ^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_exhaustive_constructor_boundary.cj:31:14:
   | 
31 |         case Right(_, false) => 3
   |              ^^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable expression
  ==> enum_table_exhaustive_constructor_boundary.cj:49:5:
   | 
45 |       match (state) {
   |  _____~
46 | |         case A => return
   | | ...
48 | |     }
   | |_____~ any code following this expression is unreachable
49 |       println("dead after trivial table")
   |       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ unreachable expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable expression
  ==> enum_table_exhaustive_constructor_boundary.cj:59:5:
   | 
53 |       match (state) {
   |  _____~
54 | |         case Left(_, true) => return
   | | ...
58 | |     }
   | |_____~ any code following this expression is unreachable
59 |       println("dead after payload table")
   |       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ unreachable expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
6 warnings generated, 6 warnings printed.
*/
