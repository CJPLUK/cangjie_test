// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -O2

import std.collection.*

class Key <: Hashable & Equatable<Key> {
    let n: Int64
    init(n: Int64) {
        this.n = n
    }
    exclave init(this @local!, n: Int64) {
        this.n = n
    }
    public func hashCode(): Int64 {
        n
    }
    public operator func ==(other: Key): Bool {
        n == other.n
    }
}

exclave func use(m: HashMap<Key, Int64> @local!, k: Key @local!): Bool {
    m.contains(k)
}

main() {
    let m: HashMap<Key, Int64> @local! = HashMap()
    let k: Key @local! = Key(1)
    use(m, k)
    0
}
