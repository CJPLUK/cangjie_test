// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

public struct M {
    func getSize(this @local?) {
        1
    }
}
public struct S {
    init(this @local!, m: M @local!) { exclave {}}
    init(m: M) {}
    public static func fromUtf8(utf8Data: M @local!): S @local! {
        let b = utf8Data.getSize()
        println(b)
        exclave { S(utf8Data) }
    }
}

main() {}