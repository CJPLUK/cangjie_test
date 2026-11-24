// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %compiler %local %enableO2 %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output

class Nq {
    var v: Int64 = 0
    init() { v = 1 }
    init(this @ local!, t: Int64) { exclave { v = t } }
}

func g(nq: Nq @ local!, fn: () -> Int64): Nq @ local! {
    return nq
}

func f(nq: Nq @ local!): Nq @ local! {
    exclave {
        return g(nq) { =>
            0
        }
    }
}

main(): Int64 {
    let x = f(Nq(1) @local!)
    if (x.v == 1) { 0 } else { 1 }
}
