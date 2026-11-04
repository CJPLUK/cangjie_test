// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../compatibility/pkg_class.cj
// EXEC: %compiler %local %compile_lib_opt pkg_class.cj -o pkg_class.%middle
// EXEC-PIPE-1: %compiler %cmp_opt pkg_class.%middle %f -o %output -Woff all 2>&1 | compare %f

import pkg_class.*

main() {
    C().mFull()
    let v = P().fullProp
    println(v)
}

/* SCAN
error: cannot use local API 'mFull(this @local!): Int64' when local mode is disabled
  ==> sema_local_api_disabled.cj:14:5:
   | 
14 |     C().mFull()
   |     ^^^^^^^^^ compile with '--experimental --enable-local-mode' to enable it
   | 

error: cannot use local API 'fullProp: Int64 @local!' when local mode is disabled
  ==> sema_local_api_disabled.cj:15:13:
   | 
15 |     let v = P().fullProp
   |             ^^^^^^^^^^^^ compile with '--experimental --enable-local-mode' to enable it
   | 

2 errors generated, 2 errors printed.
*/
