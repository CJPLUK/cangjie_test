// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %cmp_opt %enableO2 -Woff all %n.cj
// RUN-EXEC-PIPE-0: %run main

interface I {
    static func f(): String { g() }
    static func g(): String { return "I.g" }
}

open class A<T> <: I {
    public static func g(): String { h() }
    public static func h(): String { return "A.h" }
}

open class B <: A<Int64> {
    public static func h(): String { return "B.h" }
}

class C <: B {
    public static func h(): String { return "C.h" }
}

main() {
    if (C.f() != "C.h") {
        return 1
    }
    if (B.f() != "B.h") {
        return 2
    }
    if (C.g() != "C.h") {
        return 3
    }
    return 0
}
