// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %cmp_opt %f 2>&1

class A {
    static init() {
        exclave {
            ()
        }
    }
    ~init() {
        exclave {
            ()
        }
    }
}

struct F {
    static init() {
        exclave {
            ()
        }
    }
}

func foo() {
    spawn {
        exclave {
            42
        }
    }
}

main(): Int64 {
    exclave {
        42
    }
}

/* SCAN
error: cannot use exclave expression in static init
  ==> sema_exclave_in_ctor.cj:11:9:
   | 
11 |           exclave {
   |  _________^
12 | |             ()
13 | |         }
   | |_________^
   | 

error: cannot use exclave expression in finalizer
  ==> sema_exclave_in_ctor.cj:16:9:
   | 
16 |           exclave {
   |  _________^
17 | |             ()
18 | |         }
   | |_________^
   | 

error: cannot use exclave expression in static init
  ==> sema_exclave_in_ctor.cj:24:9:
   | 
24 |           exclave {
   |  _________^
25 | |             ()
26 | |         }
   | |_________^
   | 

error: cannot use exclave expression in spawn expr
  ==> sema_exclave_in_ctor.cj:32:9:
   | 
32 |           exclave {
   |  _________^
33 | |             42
34 | |         }
   | |_________^
   | 

error: cannot use exclave expression in main
  ==> sema_exclave_in_ctor.cj:39:5:
   | 
39 |       exclave {
   |  _____^
40 | |         42
41 | |     }
   | |_____^
   | 

5 errors generated, 5 errors printed.
*/
