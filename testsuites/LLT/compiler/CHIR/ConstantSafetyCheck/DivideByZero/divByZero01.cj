// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


// LEVEL: 0
// EXEC-PIPE-1: %compiler %warnOffAll %cmp_opt %f -o %output 2>&1 | compare %f

var g0 = 1
var g1 = true

public func divByZero01() {
    var a1 = 0
    var a2 = a1 / 0
    var a3 = a2 / a1
    var a4 = a2 % 0
    var a5 = g0 % 0
}

public func divByZero02() {
    var a1 = 1
    a1 /= 0
    a1 %= 0
}

public func divByZero03() {
    var a1 = 5
    var a2 = a1 + 5
    var a3 = a2 / (a1 - a2 / 2)
    var a4 = g0 % if (g1) { println(1); a1 - 5} else { println(2); a1 / 5 - 1}
}

main() {}

/* SCAN
error: divide by zero
  ==> divByZero01.cj:16:14:
   | 
16 |     var a2 = a1 / 0
   |              ^^^^^^ attempt to divide by zero
   | 

error: divide by zero
  ==> divByZero01.cj:17:14:
   | 
17 |     var a3 = a2 / a1
   |              ^^^^^^^ attempt to divide by zero
   | 

error: modulo by zero
  ==> divByZero01.cj:18:14:
   | 
18 |     var a4 = a2 % 0
   |              ^^^^^^ attempt to modulo by zero
   | 

error: modulo by zero
  ==> divByZero01.cj:19:14:
   | 
19 |     var a5 = g0 % 0
   |              ^^^^^^ attempt to modulo by zero
   | 

error: divide by zero
  ==> divByZero01.cj:24:5:
   | 
24 |     a1 /= 0
   |     ^^^^^^^ attempt to divide by zero
   | 

error: modulo by zero
  ==> divByZero01.cj:25:5:
   | 
25 |     a1 %= 0
   |     ^^^^^^^ attempt to modulo by zero
   | 

error: divide by zero
  ==> divByZero01.cj:31:14:
   | 
31 |     var a3 = a2 / (a1 - a2 / 2)
   |              ^^^^^^^^^^^^^^^^^^ attempt to divide by zero
   | 

error: modulo by zero
  ==> divByZero01.cj:32:14:
   | 
32 |     var a4 = g0 % if (g1) { println(1); a1 - 5} else { println(2); a1 / 5 - 1}
   |              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ attempt to modulo by zero
   | 

8 errors generated, 8 errors printed.
*/