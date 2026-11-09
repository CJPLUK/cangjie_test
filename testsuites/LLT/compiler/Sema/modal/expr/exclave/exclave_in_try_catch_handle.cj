// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %enableEH %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

import stdx.effect.Command

func foo(a: Int): Unit {
    try {
        exclave {
            ()
        }
    } catch (_) {
        ()
    }
}

func bar(a: Int): Unit {
    try {
        ()
    } catch (_) {
        exclave {
            ()
        }
    }
}

func baz(a: Int): Unit {
    try {
        ()
    } handle (_: Command<Unit>) {
        exclave {
            ()
        }
    }
}

func nested(a: Int): Unit {
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

main() {}

/* SCAN
error: cannot use exclave expression in try block
  ==> exclave_in_try_catch_handle.cj:13:9:
   | 
13 |           exclave {
   |  _________^
14 | |             ()
15 | |         }
   | |_________^
   | 

error: cannot use exclave expression in catch block
  ==> exclave_in_try_catch_handle.cj:25:9:
   | 
25 |           exclave {
   |  _________^
26 | |             ()
27 | |         }
   | |_________^
   | 

error: cannot use exclave expression in handle block
  ==> exclave_in_try_catch_handle.cj:35:9:
   | 
35 |           exclave {
   |  _________^
36 | |             ()
37 | |         }
   | |_________^
   | 

error: cannot use exclave expression in try block
  ==> exclave_in_try_catch_handle.cj:43:9:
   | 
43 |           exclave {
   |  _________^
44 | |             exclave {
   | | ...
47 | |         }
   | |_________^
   | 

error: exclave cannot be nested
  ==> exclave_in_try_catch_handle.cj:44:13:
   | 
43 |            exclave {
   |  __________~
44 | |              exclave {
   | | _____________^
45 | ||                 ()
46 | ||             }
   | ||_____________^ outer exclave is here
47 | |          }
   | |__________~
   | 

5 errors generated, 5 errors printed.
*/
