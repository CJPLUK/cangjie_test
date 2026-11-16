// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Check body conditions and nested matches after body blocks merge into enum pattern entries.
// EXEC-PIPE-0: %compiler %cmp_opt -O2 %f -o %output 2>&1 | compare %f

enum E { A(Int64, Int64) | B }
func bodyIf(): Int64 {
    return match (E.A(1, 2)) {
        case A(_, _) => if (false) { 10 } else { 20 }
        case B => 30
    }
}
func bodyTable(): Int64 {
    return match (E.A(1, 2)) {
        case A(_, _) => match (E.B) {
            case A(1, _) => 10
            case B => 20
            case _ => 40
        }
        case B => 30
    }
}
func bodyLet(): Int64 {
    return match (E.A(1, 2)) {
        case A(_, _) =>
            if (let A(1, _) <- E.A(1, 2)) { println("if let") }
            while (let A(1, _) <- E.B) { break }
            20
        case B => 30
    }
}
main() { println(bodyIf()); println(bodyTable()); println(bodyLet()) }

/* SCAN-IN
warning: unreachable block in 'if' expression
  ==> enum_table_merged_body.cj:13:36:
   | 
13 |         case A(_, _) => if (false) { 10 } else { 20 }
   |                                    ^^^^^^ unreachable block in 'if' expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_merged_body.cj:14:14:
   | 
14 |         case B => 30
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_merged_body.cj:20:18:
   | 
20 |             case A(1, _) => 10
   |                  ^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_merged_body.cj:22:18:
   | 
22 |             case _ => 40
   |                  ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_merged_body.cj:24:14:
   | 
24 |         case B => 30
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable block in 'while' expression
  ==> enum_table_merged_body.cj:31:24:
   | 
31 |             while (let A(1, _) <- E.B) { break }
   |                        ^^^^^^^ unreachable block in 'while' expression
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> enum_table_merged_body.cj:33:14:
   | 
33 |         case B => 30
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/
