// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -O2 -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

class Box {
    public var n: Int64 = 0
    public init(n: Int64) {
        this.n = n
    }
    public exclave init(this @local!, n: Int64) {
        this.n = n
    }
}

exclave func unwrap(o: Option<Box> @local!): Int64 {
    match (o) {
        case Some(b) => b.n
        case None => -1
    }
}

main() {
    let _: String @local! = run()
    0
}

exclave func run(): String @local! {
    let o: Option<Box> @local! = Box(42) @local!
    println(unwrap(o))
    "ok"
}

/* SCAN
42
*/
