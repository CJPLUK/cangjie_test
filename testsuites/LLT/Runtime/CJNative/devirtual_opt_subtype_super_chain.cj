// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Walking the super class chain of `A` reaches `std.core:Object`, which is
// declared in another module and has no initializer here, so `A <: B` can not
// be decided from the metadata visible in this module. The check must stay a
// runtime call instead of being folded.
// EXEC: %compiler %cmp_opt %f -o %n.o0
// RUN-EXEC: %run %run_opt %n.o0
// EXEC: %compiler %cmp_opt %f %enableO2 -o %n.o2
// RUN-EXEC: %run %run_opt %n.o2

class A {}

class B {}

main(): Int64 {
    var a: Any = A()
    if (a is B) {
        return 1
    }
    return 0
}
