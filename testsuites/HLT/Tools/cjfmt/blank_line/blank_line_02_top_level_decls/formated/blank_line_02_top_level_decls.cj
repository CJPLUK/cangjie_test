/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

var a = 0

var b = 0

let c = 1

let d = 2

func f1(): Int64 {
    return a + b
}

func f2(): Int64 {
    return c + d
}

class C {
    var a = 0

    var b = 0

    let c = 1

    let d = 2
    public func m(): Int64 {
        return 9
    }
}

class D {}

main() {
    println(f1())
    println(f2())
    println(C().m())
}
