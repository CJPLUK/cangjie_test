// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %diag_json %f -o %output
// EXEC: %run %run_opt %output %run_args

class Nq {
    var v: Int64 = 0
    init() { v = 1 }
    init(this @local!, t: Int64) { exclave { v = t } }
}

func g(nq: Nq @local!, fn: () -> Int64): Nq @local! {
    return nq
}

func optional(nq: Nq @local!, fn: ?() -> Int64): Nq @local! {
    return nq
}

func explicitReturn(nq: Nq @local!): Nq @local! {
    exclave {
        return g(nq) { => 0 }
    }
}

func parenthesizedReturn(nq: Nq @local!): Nq @local! {
    exclave {
        return (g(nq) { => 0 })
    }
}

func implicitReturn(nq: Nq @local!): Nq @local! {
    exclave {
        g(nq) { => 0 }
    }
}

func optionalReturn(nq: Nq @local!): Nq @local! {
    exclave {
        return optional(nq) { => 0 }
    }
}

main(): Int64 {
    let a = explicitReturn(Nq(1) @local!)
    let b = parenthesizedReturn(Nq(2) @local!)
    let c = implicitReturn(Nq(3) @local!)
    let d = optionalReturn(Nq(4) @local!)
    return a.v + b.v + c.v + d.v - 10
}
