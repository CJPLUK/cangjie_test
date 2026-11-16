// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -Woff all

class C {
    init() {}
    exclave init(this @local!) {}
}

exclave func take(c: C @local!, u: Unit @local!): Int64 {
    0
}

exclave func f(c: C @local!): Int64 {
    take(c, ())
}

main() {
    let c: C @local! = C()
    f(c)
}
