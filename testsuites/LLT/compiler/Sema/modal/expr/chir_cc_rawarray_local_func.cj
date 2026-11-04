// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output -O2
// RUN-EXEC: %run %run_opt %output %run_args
import std.collection.*

type Handler = (Int32) -> Bool

func pred(x: Int32): Bool {
    x > 0
}

func register(): Unit {
    let handlers = ArrayList<Handler>()
    handlers.add(pred)
}

main(): Int64 {
    register()
    0
}
