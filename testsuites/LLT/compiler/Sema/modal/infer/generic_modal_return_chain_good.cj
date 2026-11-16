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

func lift<T>(x: T): T @local? where T <: ITag {
    exclave { x }
}

func liftFull<T>(x: T @local!): T @local! where T <: ITag {
    exclave { x }
}

func relift<T>(x: T @local?): T @local? where T <: ITag {
    exclave {
        let _: Int64 = x.tag()
        x
    }
}

func tagOf<T>(x: T @local!): Int64 where T <: ITag {
    exclave {
        x.tag()
    }
}

main(): Int64 {
    let d: D = D(11)
    let r1: D @local? = lift(d)
    let r2: D @local? = relift(r1)
    let d_full: D @local! = D(13)
    let r3: D @local! = liftFull(d_full)
    let n: Int64 = tagOf(r3)
    let _: Int64 = r1.id + r2.id + n
    0
}
