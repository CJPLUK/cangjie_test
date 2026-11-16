// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC-PIPE-1: %compiler %warnOffAll %cmp_opt %f -o %output 2>&1 | compare %f

public func divByZero01() {
   var a = 1
   var b = a
   b = 2
   var c = 2 / (a - 1)
   println(c)
}

public func divByZero02() {
   let a = 1
   var b = a
   b = 2
   var c = 2 / (a - 1)
   println(c)
}

main() {}

/* SCAN
error: divide by zero
  ==> divByZero02.cj:14:12:
   | 
14 |    var c = 2 / (a - 1)
   |            ^^^^^^^^^^^ attempt to divide by zero
   | 

error: divide by zero
  ==> divByZero02.cj:22:12:
   | 
22 |    var c = 2 / (a - 1)
   |            ^^^^^^^^^^^ attempt to divide by zero
   | 

2 errors generated, 2 errors printed.
*/
