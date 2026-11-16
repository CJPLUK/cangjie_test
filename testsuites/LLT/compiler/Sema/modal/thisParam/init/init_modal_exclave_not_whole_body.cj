// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -o %output %cmp_opt 2>&1 | compare %f

class C {
    init(this @local!) {
        exclave {
            ()
        }
        ()
    }
}

main() {}

/* SCAN
error: whole body of @local! constructor must be in exclave
  ==> init_modal_exclave_not_whole_body.cj:11:9:
   | 
11 |           exclave {
   |  _________^
12 | |             ()
13 | |         }
   | |_________^
   | 

1 error generated, 1 error printed.
*/
