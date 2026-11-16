// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// (CJNATIVE) EXEC-PIPE-0: %run %run_opt %output %run_args

private let scoreTuple = ("", true)
private var scoreResult: String = match (scoreTuple) {
    case ("", true) => "zero"
    case ("aa", true) => "zero"
    case ("aa", true) => "zero"
    case (_, false) => "zero"
    case (_, false) => "zero"
    case (_, true) => "zero"
    case (_, _) => "zero"
}

main() {
    return 0
}

/* SCAN
warning: unreachable pattern
  ==> testDCEMatch03.cj:14:10:
   | 
14 |     case ("aa", true) => "zero"
   |          ^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unreachable pattern
  ==> testDCEMatch03.cj:16:10:
   | 
16 |     case (_, false) => "zero"
   |          ^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unreachable pattern
  ==> testDCEMatch03.cj:18:10:
   | 
18 |     case (_, _) => "zero"
   |          ^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'scoreResult'
  ==> testDCEMatch03.cj:11:13:
   | 
11 | private var scoreResult: String = match (scoreTuple) {
   |             ^^^^^^^^^^^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unreachable pattern
  ==> testDCEMatch03.cj:15:10:
   | 
15 |     case (_, false) => "zero"
   |          ^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

5 warnings generated, 5 warnings printed.
*/

// String equality calls are not modeled by constant analysis yet; later cases remain potentially reachable.
