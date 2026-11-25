// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 整体 struct 拷贝进 local! 对象的 demode 字段必须走 local-aware 聚合写
// （回归用例，覆盖 issue #1325）。
// 场景：Crate @local! / BoxS @local! 的 demode struct 字段（w: Wrap / d: SC）在
// 构造函数 exclave 中整体赋值。struct payload 含 heap class 引用槽，聚合写退化为
// 普通 llvm.cj.gcwrite.struct 时槽位不登记，GC 翻搅后 w.cell.v 读到被复用内存
// （输出 9 或翻搅值 7）。结构体赋值路径（EmitStructFieldWriteBarrier -> gcwrite.struct）
// 必须保持 modalWrite 信息并使用 MaybeLocalWriteStruct 类入口。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var v: Int64
    init(this @ ~local, x: Int64) { v = x }
}

struct Wrap {
    let cell: Cell
    init(c: Cell) { this.cell = c }
}

class Crate {
    demode var w: Wrap
    init(this @ ~local, pw: Wrap) { w = pw }
    init(this @ local!, pw: Wrap) { exclave { w = pw } }
    func read(this @ local?): Int64 { w.cell.v }
}

class C {
    var w: Int64
    init(this @ ~local, x: Int64) { w = x }
}

struct SC {
    let c: C
    init(c: C) { this.c = c }
}

class BoxS {
    demode var d: SC
    init(this @ ~local, s: SC) { d = s }
    init(this @ local!, s: SC) { exclave { d = s } }
    func readD(this @ local?): Int64 { d.c.w }
}

main(): Int64 {
    let w0 = Wrap(Cell(42))
    let b = Crate(w0) @ local!
    let s = SC(C(42))
    let b2 = BoxS(s) @ local!
    var acc: Int64 = 0
    var i: Int64 = 0
    while (i < 2000000) {
        let g = Cell(9)
        acc += g.v
        if (acc > 100000000) { acc = 0 }
        i += 1
    }
    let r = b.read()
    let r2 = b2.readD()
    println("r=${r} r2=${r2}")
    if (r == 42 && r2 == 42) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
