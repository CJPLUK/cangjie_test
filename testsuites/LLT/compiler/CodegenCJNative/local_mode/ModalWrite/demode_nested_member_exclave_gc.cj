// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: exclave 中对 local! 对象嵌套 struct 成员的 class 引用赋值必须登记
// local root（回归用例，覆盖 issue #1323 的 Store/Outer/Inner 场景）。
// 场景：Store @local! 的 demode 字段 outer: Outer（内联 struct）经两层成员路径
// 写 outer.i.c。物理槽位在 local StoreA 对象内部；分类时不能沿语义模态链
// （demode -> ~local -> 继承）判定为 heap->heap 普通写，否则 exclave 中写入的
// Cell(42) 未登记，翻搅后被回收，readW 返回翻搅对象的 9。

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

struct Outer {
    var i: Inner
    init(i: Inner) { this.i = i }
}

class Store {
    demode var outer: Outer
    init(this @ ~local, o: Outer) { outer = o }
    init(this @ local!, o: Outer) { exclave { outer = o } }
    func setInnerC(this @ local!, c: Cell): Unit { exclave { outer.i.c = c } }
    func readW(this @ local?): Int64 { outer.i.c.v }
}

main(): Int64 {
    let b = Store(Outer(Inner(Cell(1)))) @ local!
    b.setInnerC(Cell(42))
    var acc: Int64 = 0
    var i: Int64 = 0
    while (i < 2000000) {
        let g = Cell(9)
        acc += g.v
        i += 1
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
