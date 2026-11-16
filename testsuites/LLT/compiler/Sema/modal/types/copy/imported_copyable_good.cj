// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_imported_copyable.cj
// EXEC: %compiler %local %compile_lib_opt pkg_imported_copyable.cj -o mylib.%middle
// EXEC: %compiler %local mylib.%middle %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

package demo

import mylib.*

func w2(h: Holder2 @ local!) {
    let s: CCopy @ local! = CCopy() @ local!
    h.c = s
}

main(): Int64 {
    let h: Holder2 @ local! = Holder2() @ local!
    w2(h)
    let copied: ExtendedCopy @local! = ExtendedCopy()
    let heap: ExtendedCopy = copied
    if (h.c.v != 0 || heap.v != 1) { return 1 }
    0
}
