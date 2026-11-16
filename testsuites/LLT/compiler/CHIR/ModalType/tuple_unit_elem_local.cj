// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -Woff all

struct Entry {
    let k: Rune
    let v: Unit
    init(k: Rune, v: Unit) {
        this.k = k
        this.v = v
    }
    exclave init(this @local!, k: Rune, v: Unit) {
        this.k = k
        this.v = v
    }
}

exclave func pair(e: Entry @local!): (Rune, Unit) @local! {
    (e.k, e.v)
}

main() {
    let e: Entry @local! = Entry(r'a', ())
    let _: (Rune, Unit) @local! = pair(e)
}
