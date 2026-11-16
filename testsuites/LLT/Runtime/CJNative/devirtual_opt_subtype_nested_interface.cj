// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Checking `(A) -> Unit` against `(I) -> Unit` recurses into the contra-variant
// parameter `I <: A`. The interface relation depends on extension data and can
// not be decided by `CJDevirtualOpt`, which used to abort -O2 with `The
// interface type is processed in subtype.!`. The check must stay a runtime call.
// EXEC: %compiler %cmp_opt %f -o %n.o0
// RUN-EXEC: %run %run_opt %n.o0
// EXEC: %compiler %cmp_opt %f %enableO2 -o %n.o2
// RUN-EXEC: %run %run_opt %n.o2

interface I {}

class A <: I {}

func foo1(x: A): Unit {}

func foo2(x: A): Unit {}

main(): Int64 {
    var b = if (false) {
        foo1
    } else {
        foo2
    }
    // `b` holds a `(A) -> Unit` closure, and `I <: A` is false, so `b` is not
    // a `(I) -> Unit`.
    if (b is (I) -> Unit) {
        return 1
    }
    return 0
}
