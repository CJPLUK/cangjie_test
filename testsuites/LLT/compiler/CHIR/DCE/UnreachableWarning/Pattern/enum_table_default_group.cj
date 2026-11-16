// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Group the default case with enum diagnostics without excluding payload-failure paths to it.
// EXEC-PIPE-0: %compiler %cmp_opt -O2 %f -o %output 2>&1 | compare %f

enum E { A(Int64, Bool) | B }
func selectedB(): Int64 {
    return match (E.B) {
        case A(0, true) => 10
        case B => 20
        case _ => 30
    }
}
func selectedA(value: Int64, flag: Bool): Int64 {
    return match (E.A(value, flag)) {
        case A(0, true) => 10
        case B => 20
        case _ => 30
    }
}
main() { println(selectedB()); println(selectedA(1, false)) }

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_default_group.cj:13:14:
   | 
13 |         case A(0, true) => 10
   |              ^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_default_group.cj:15:14:
   | 
15 |         case _ => 30
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_default_group.cj:21:14:
   | 
21 |         case B => 20
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
