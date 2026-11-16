// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %enableEH %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

import stdx.effect.Command

class C {
    init() {}
}
func nested(c: C @local!): Unit {
    try {
        exclave {
            exclave {
                ()
            }
        }
    } catch (_) {
        ()
    }
}

func nestedCatch(c: C @local!): Unit {
    try { () } catch (_) {
        try { () } catch (_) { () }
        exclave { () }
    }
}

func nestedHandle(c: C @local!): Unit {
    try { () } handle (_: Command<Unit>) {
        try { () } handle (_: Command<Unit>) { () }
        exclave { () }
    }
}

func tryExclave(c: C @local!) {
    try { exclave { () } } finally { () }
}

main() {}

/* SCAN
error: cannot use exclave expression in try block
  ==> exclave_in_nested_try.cj:16:9:
   | 
16 |           exclave {
   |  _________^
17 | |             exclave {
   | | ...
20 | |         }
   | |_________^
   | 

error: exclave cannot be nested
  ==> exclave_in_nested_try.cj:17:13:
   | 
16 |            exclave {
   |  __________~
17 | |              exclave {
   | | _____________^
18 | ||                 ()
19 | ||             }
   | ||_____________^ outer exclave is here
20 | |          }
   | |__________~
   | 

error: cannot use exclave expression in catch block
  ==> exclave_in_nested_try.cj:29:9:
   | 
29 |         exclave { () }
   |         ^^^^^^^^^^^^^^ 
   | 

error: cannot use exclave expression in handle block
  ==> exclave_in_nested_try.cj:36:9:
   | 
36 |         exclave { () }
   |         ^^^^^^^^^^^^^^ 
   | 

error: cannot use exclave expression in try block
  ==> exclave_in_nested_try.cj:41:11:
   | 
41 |     try { exclave { () } } finally { () }
   |           ^^^^^^^^^^^^^^ 
   | 

5 errors generated, 5 errors printed.
*/
