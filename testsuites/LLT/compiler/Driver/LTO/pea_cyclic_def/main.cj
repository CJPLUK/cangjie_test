// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (Linux and CJNATIVE) DEPENDENCE: dep.cj
// Debug info preserves the aggregate-copy IR shape that exposed the cycle.
// (Linux and CJNATIVE) EXEC: %compiler %cmp_opt -g --lto=full --output-type=staticlib dep.cj -o libdep.bc
// (Linux and CJNATIVE) EXEC: %compiler %cmp_opt %enableO2 -g --dy-std --lto=full %f libdep.bc -o %output
// (Linux and CJNATIVE) RUN-EXEC: %run %run_opt %output %run_args

package app
import dep

main(): Int64 {
    var b = dep.Box<Int64>(1, "a", 0)
    if (b.x != 1) {
        return 1
    }
    b.set("b")
    if (b.get() != "b") {
        return 1
    }
    return 0
}
