// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %cmp_opt %enableO2 -Woff all %n.cj
// RUN-EXEC-PIPE-0: %run main

// The static-method reference's lambda binds This when the instance method is instantiated.
interface I {
    func call(): String
    static func target(): String
}

open class Base<T> <: I {
    public open func call(): String {
        let f = target
        return f()
    }

    public static func target(): String { "Base.target" }
}

class First <: Base<Int64> {
    public static func target(): String { "First.target" }
}

class Second <: Base<Int64> {
    public static func target(): String { "Second.target" }
}

main() {
    let first: I = First()
    let second: I = Second()
    let a = first.call()
    let b = second.call()
    if (a != "First.target") {
        return 1
    }
    if (b != "Second.target") {
        return 2
    }
    return 0
}
