// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1

class C {
    public var s: String = ""
    init() {}
}

func take(s: String @local!) {}

func f(c: C @local!) {
    take(c.
        s)
}

main() {}

/* SCAN
error: cannot pass argument of external @local! to @local! parameter
  ==> sema_external_local_arg.cj:17:10:
   | 
17 |       take(c.
   |  __________^
18 | |         s)
   | |_________^
   | 

1 error generated, 1 error printed.
*/
