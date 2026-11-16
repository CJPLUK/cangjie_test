// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

class C {
    exclave init(this @local!) {}
}
func foo(): C@local! {
    exclave {
        exclave {
            C()
        }
    }
}
main() {}

/* SCAN
error: exclave cannot be nested
  ==> sema_nested_exclave.cj:14:9:
   | 
13 |        exclave {
   |  ______~
14 | |          exclave {
   | | _________^
15 | ||             C()
16 | ||         }
   | ||_________^ outer exclave is here
17 | |      }
   | |______~
   | 

1 error generated, 1 error printed.
*/
