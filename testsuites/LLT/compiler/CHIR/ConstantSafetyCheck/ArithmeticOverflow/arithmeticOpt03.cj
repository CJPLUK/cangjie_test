// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Const init overflow diagnostic must keep the expression DebugLocation (Issue #3536).
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

const badNeg: Int8 = -(-128)

main(): Int64 {
    println(badNeg)
    return 0
}

/* SCAN
error: arithmetic operation '-' overflow
  ==> arithmeticOpt03.cj:11:22:
   | 
11 | const badNeg: Int8 = -(-128)
   |                      ^^^^^^^ operation '-Int8(-128)' would overflow
   | 
   # note: range of Int8 is -128 ~ 127

1 error generated, 1 error printed.
*/
