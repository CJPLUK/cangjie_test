// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify an unreachable enum constructor table reports source cases without splitting or-pattern alternatives.
// EXEC-PIPE-0: %compiler %cmp_opt -O2 %f -o %output 2>&1 | compare %f

enum State {
    | Active(Int64, Int64)
    | Stopped
}

main() {
    const state = State.Stopped
    let keyedResult = match (state) {
        case Active(1, 0) | Active(1, 1) => 0
        case Active(1, 2) => 1
        case Active(2, 0) => 2
        case _ => 3
    }
    println(keyedResult)

    let fallbackResult = match (state) {
        case Active(1, 1) | Active(_, 2) => 0
        case Active(_, _) => 1
        case _ => 2
    }
    println(fallbackResult)
}

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_sibling_cases.cj:18:14:
   | 
18 |         case Active(1, 0) | Active(1, 1) => 0
   |              ^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_sibling_cases.cj:19:14:
   | 
19 |         case Active(1, 2) => 1
   |              ^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_sibling_cases.cj:20:14:
   | 
20 |         case Active(2, 0) => 2
   |              ^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_sibling_cases.cj:26:14:
   | 
26 |         case Active(1, 1) | Active(_, 2) => 0
   |              ^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_sibling_cases.cj:27:14:
   | 
27 |         case Active(_, _) => 1
   |              ^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
