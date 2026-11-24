// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %compiler %local %enableO2 %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output

class C {
    let x: Int64 = 1
    init(this @ local!) {
        exclave { }
    }
    func self2(this @ local!): C @local! {
        return this
    }
}

func f(a: ?C @local!): ?C @local! {
    exclave {
        return a?.self2()
    }
}

main(): Int64 {
    let a: ?C @local! = Some(C() @local!)
    let result = f(a)
    match (result) {
        case Some(v) => if (v.x == 1) { 0 } else { 1 }
        case None => 1
    }
}

