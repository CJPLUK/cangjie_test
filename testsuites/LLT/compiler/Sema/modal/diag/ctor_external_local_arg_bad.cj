// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1

class T {}

class C {
    init(a: T @local!) {}
}

func f(x: T @local!): Unit {
    let c = C(x)
    c
}

main() {}

/* SCAN
error: cannot pass argument of external @local! to @local! parameter
  ==> ctor_external_local_arg_bad.cj:16:15:
   | 
16 |     let c = C(x)
   |               ^ 
   | 

1 error generated, 1 error printed.
*/
