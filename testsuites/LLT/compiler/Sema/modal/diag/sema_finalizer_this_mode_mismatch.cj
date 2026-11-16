// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %cmp_opt %f

class C {
    init() {}
    init(this @local!) {
        exclave {}
    }
    ~init(this @local!) {}
}
main() {}
/* SCAN
error: finalizer this mode '@local!' must be a supertype of the least upperbound of all initializer this mode '@local?'
  ==> sema_finalizer_this_mode_mismatch.cj:14:5:
   | 
14 |     ~init(this @local!) {}
   |     ^^^^^^^^^^^^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
