// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1

class C {
    init() {}
    prop p: Int64 @local! {
        get() { exclave { 1 } }
    }
}
struct P <: Copyable {
    init() {}
    prop p: Int64 @local! {
        get() { exclave { 1 } }
    }
}
main() {}
/* SCAN
error: exclave must be used in function with @local! non copy param or @local!/@local? non copy return type
  ==> getter_exclave_bad.cj:18:17:
   | 
18 |         get() { exclave { 1 } }
   |                 ^^^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
