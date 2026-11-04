// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1

class C {
    init() {}
    static prop p: String {
        get() { "" }
    }
    static prop p: String @local! {
        get() { exclave {""() } }
    }
}
main() {}

/* SCAN
error: static property cannot be overloaded
  ==> static_overload_bad.cj:11:5:
   | 
11 |       static prop p: String {
   |  _____^
12 | |         get() { "" }
13 | |     }
   | |_____^
   | 

error: static property cannot be overloaded
  ==> static_overload_bad.cj:14:5:
   | 
14 |       static prop p: String @local! {
   |  _____^
15 | |         get() { exclave {""() } }
16 | |     }
   | |_____^
   | 

2 errors generated, 2 errors printed.
*/
