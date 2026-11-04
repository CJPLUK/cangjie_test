// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args | compare %f

class Box {
    var n: Int64
    init(n: Int64) { this.n = n }
    exclave init(this @local!, n: Int64) { this.n = n }
}

class Tag {
    var n: Int64
    init(n: Int64) { this.n = n }
    exclave init(this @local!, n: Int64) { this.n = n }
    public operator func ()(x: Int64): Int64 {
        x + n
    }
}

func widen(n: Int64): Tag {
    let b = Box(n) @local!
    Tag(b.n + 1)
}

func narrow(t: Tag): Int64 {
    let b = Box(t.n) @local!
    b.n * 2
}

func id(input: Int64): Int64 {
    let b = Box(input) @local!
    b.n
}

func take(input: Int64) {
    let _ = Box(input) @local!
}

func take(input: (Int64) -> Int64) {
    input(0)
}

main() {
    let fg = widen ~> narrow ~> widen ~> narrow
    let direct = (widen ~> narrow)(1)
    let a = Tag(1)
    let b = Tag(0)
    let local = Tag(1) @local!
    let called = (a ~> b)(local.n)
    take(0)
    let composed = (id ~> id)(3)
    take(id ~> id)
    let chained = fg(1)
    println("${chained} ${direct} ${called} ${composed}")
    if (chained == 10 && direct == 4 && called == 2 && composed == 3) {
        0
    } else {
        1
    }
}

/* SCAN
10 4 2 3
*/
