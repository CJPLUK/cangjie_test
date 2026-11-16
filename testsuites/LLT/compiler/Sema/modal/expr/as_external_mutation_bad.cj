// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class V {
    public var x: Int64 = 123
    public init(this @ local!) { exclave { x = 111 } }
}
class Cell {
    public var payload: V
    public init(this @ local!) { exclave { payload = V() @ local! } }
}
func f(c: Cell @ local!) {
    let iv = V() @ local!
    let o = c as Cell
    match (o) {
        case Some(d) => d.payload = iv
        case None => ()
    }
}
main(): Int64 {
    let cell: Cell @ local! = Cell() @ local!
    println("BEFORE ${cell.payload.x}")
    f(cell)
    println("AFTER ${cell.payload.x}")
    0
}

// ASSERT: scan "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 1,
