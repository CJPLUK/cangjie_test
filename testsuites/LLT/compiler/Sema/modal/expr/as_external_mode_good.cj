// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var value: Int64 = 42
    init() {}
    init(this @local!) { exclave {} }
}

func mode(_: ?Cell @local!): Int64 { 1 }
func mode(_: ?Cell @local?): Int64 { 2 }

func external(c: Cell @local!): Int64 {
    let o = (((c))) as Cell
    mode(o)
}

func internal(): Int64 {
    let c = Cell() @local!
    let o: ?Cell @local! = c as Cell
    mode(o)
}

func inExclave(c: Cell @local!): Int64 {
    exclave {
        let o: ?Cell @local! = (((c))) as Cell
        mode(o)
    }
}

func maybe(c: Cell @local?): Int64 {
    let o = c as Cell
    mode(o)
}

func heap(): Int64 {
    let c = Cell()
    let o: ?Cell = c as Cell
    match (o) {
        case Some(d) => d.value
        case None => 0
    }
}

main(): Int64 {
    let c = Cell() @local!
    if (external(c) != 2 || internal() != 1 || inExclave(c) != 1 || maybe(c) != 2 || heap() != 42) {
        return 1
    }
    return 0
}
