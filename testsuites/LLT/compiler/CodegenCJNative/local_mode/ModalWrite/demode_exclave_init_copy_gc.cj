// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: exclave init 中把含引用槽的 struct 拷贝进 demode 字段（回归用例，覆盖 issue #1323
// 的构造器形态）。`i = i0` 是对 demode struct 字段的聚合写：物理存储在 local! 的 StoreA
// 内部，且 Cell 引用槽从此固定在 region 内，必须登记 region->heap 边；若聚合写退化为普通
// llvm.cj.gcwrite.struct，GC 翻搅后 readW 读到被复用内存（输出 9）。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var v: Int64
    init(this @ ~local, x: Int64) { v = x }
}

struct Inner {
    var c: Cell
    init(c: Cell) { this.c = c }
}

class StoreA {
    demode var i: Inner
    init(this @ ~local, i0: Inner) { i = i0 }
    init(this @ local!, i0: Inner) { exclave { i = i0 } }
    func readW(this @ local?): Int64 { i.c.v }
}

main(): Int64 {
    let b = StoreA(Inner(Cell(42))) @ local!
    var j: Int64 = 0
    while (j < 2000000) {
        let g = Cell(9)
        j += 1
    }
    let r = b.readW()
    println("r=${r}")
    if (r == 42) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
