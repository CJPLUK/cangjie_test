// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface ITag {
    func tag(this @local?): Int64
    func tag(this @local!): Int64
}

class D <: ITag {
    var id: Int64
    init(i: Int64) { id = i }
    init(this @local!, i: Int64) { exclave { id = i } }
    init(this @local?, i: Int64) { exclave { id = i } }
    public func tag(this @local?): Int64 { id }
    public func tag(this @local!): Int64 { id }
}

func computeTag<T>(x: T @local!): Int64 where T <: ITag {
    exclave {
        x.tag()
    }
}

func computeTagPair<T>(x: T @local!, y: T @local!): (Int64, Int64) where T <: ITag {
    exclave {
        (computeTag(x), computeTag(y))
    }
}

main(): Int64 {
    let d1: D @local! = D(5)
    let d2: D @local! = D(7)
    let (a, b) = computeTagPair(d1, d2)
    let _: Int64 = a + b
    0
}
