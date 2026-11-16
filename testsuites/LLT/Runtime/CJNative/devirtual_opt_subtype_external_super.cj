// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// `C` instance vs closure type: the super class type info of `C`
// (`std.core:Object`) is declared in another module, so the relation is unknown
// here and must be answered by the runtime. Reading it used to crash the
// compiler at -O2.
// EXEC: %compiler %cmp_opt %f -o %n.o0
// RUN-EXEC: %run %run_opt %n.o0
// EXEC: %compiler %cmp_opt %f %enableO2 -o %n.o2
// RUN-EXEC: %run %run_opt %n.o2

class C {}

main(): Int64 {
    var c: Any = C()
    if (c is (Rune) -> Unit) {
        return 1
    }
    return 0
}
