// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -Woff all

struct E {
    let x = 1
    init() {}
}
extend E <: Copyable {}

@C struct CS {
    var x: Int32
    init() { x = 0 }
}

func demodeE(v: E @local!): E {
    v
}

func demodeCS(v: CS @local!): CS {
    v
}

main() {
    let e: E @local! = E()
    let c: CS @local! = CS()
    let _: E = demodeE(e)
    let _: CS = demodeCS(c)
}
