// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class V { init(this @local!) { exclave {} } }

class Cell {
    var payload: V
    init(this @local!) { exclave { payload = V() @local! } }
    func fromThis(this @local!) {
        let o = this as Cell
        match (o) {
            case Some(d) => d.payload = V() @local!
            case None => ()
        }
    }
}

class Holder {
    var cell: Cell
    init(this @local!) { exclave { cell = Cell() @local! } }
}

func parenthesized(c: Cell @local!) {
    let o = (((c))) as Cell
    match (o) {
        case Some(d) => d.payload = V() @local!
        case None => ()
    }
}

func member(h: Holder @local!) {
    let o = h.cell as Cell
    match (o) {
        case Some(d) => d.payload = V() @local!
        case None => ()
    }
}

func tupleElement(t: (Cell, Int64) @local!) {
    let o = (((t[0]))) as Cell
    match (o) {
        case Some(d) => d.payload = V() @local!
        case None => ()
    }
}

struct S { var value: Int64 = 0 }

func varrayElement(a: VArray<S, $1> @local!) {
    let o: ?S @local! = a[0] as S
}

func checked(c: Cell @local!) {
    let o: ?Cell @local! = c as Cell
}

func copyableBase(n: Int64 @local!) {
    let o: ?Int64 @local! = n as Int64
}

func returned(c: Cell @local!): ?Cell @local! {
    c as Cell
}

main() {}

// ASSERT: scan-4 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan-4 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 8,
