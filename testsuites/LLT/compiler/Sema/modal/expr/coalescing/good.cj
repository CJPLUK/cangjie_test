// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args | compare %f
import std.core

class A {
    var n: Int64
    init(n: Int64) { this.n = n }
    exclave init(this @local!, n: Int64) { this.n = n }
}

exclave func use(o: Option<A> @local!): A @local! {
    o ?? A(0)
}

exclave func orZero(n: Option<Int64> @local!): Int64 {
    n ?? 0
}

func toAny(o: Option<Int64> @local!): Any {
    o ?? 0
}

main() {
    let o: Option<A> @local! = A(1) @local!
    let n: Option<Int64> @local! = None<Int64>
    let _ = core.Option<Int64>.None
    let x = use(o)
    let y = orZero(n)
    let _: Any = toAny(Some(2))
    println("${x.n} ${y}")
}

/* SCAN
1 0
*/
