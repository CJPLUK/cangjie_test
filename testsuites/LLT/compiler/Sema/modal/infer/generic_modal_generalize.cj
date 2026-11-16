// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

interface ITag {
    func tag(this @local!): Int64
}

class D <: ITag {
    var n: Int64 = 0
    init(n: Int64) {
        this.n = n
    }
    init(this @local!, n: Int64) {
        exclave { this.n = n }
    }
    public func tag(this @local!): Int64 {
        n
    }
}

exclave func compute<T>(x: T @local!, y: T @local!): (Int64, Int64) where T <: ITag {
    (x.tag(), y.tag())
}

func f() {
    let d1: D @local! = D(5)
    let d2: D @local! = D(7)
    let r = compute(d1, d2)
}

main() {
    f()
}
