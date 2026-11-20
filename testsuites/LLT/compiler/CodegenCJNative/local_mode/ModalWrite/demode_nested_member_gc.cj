// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 写入 local! 对象内联 struct 字段的嵌套成员时必须登记 local root
// （回归用例，覆盖 issue #1320 / #1323）。
// 场景：Holder @local! 的 demode struct 字段 d: W 的成员 d.c 是 heap class 引用；
// StoreElementByName(d, c) 的物理写入槽位于 local Holder 对象内部（struct 内联存储），
// 不能因为 demode 把字段的语义模态 ~local 误当成"物理 owner 在 heap"而退化为普通
// gcwrite.ref —— 普通屏障对 local owner 直接写值不登记，GC 翻搅后 d.c.y 读到被复用
// 内存（如输出 2368063）。嵌套两层 struct（Outer/Inner）与一层 struct 同理。
// 同时对照直接 demode 引用字段 f（demode.write.ref 路径）保持不受回归影响。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var y: Int64
    init(this @ ~local) { y = 42 }
}

struct W {
    var c: Cell
    init(this @ ~local) { c = Cell() }
}

class Junk {
    var t: Int64
    init(this @ ~local, i: Int64) { t = 1000000 + i }
}

class Holder {
    demode var d: W
    demode var f: Cell
    init(this @ local!) { exclave { d = W(); f = Cell() } }
    func setF(this @ local!): Unit { f = Cell() }
    func setDC(this @ local!): Unit { d.c = Cell() }
    func readF(this @ local?): Int64 { f.y }
    func readDC(this @ local?): Int64 { d.c.y }
}

main(): Int64 {
    let a: Holder @local! = Holder() @local!
    a.setF()
    a.setDC()
    var acc: Int64 = 0
    var i: Int64 = 0
    while (i < 2000000) {
        let j = Junk(i)
        acc += j.t % 7
        i += 1
    }
    let rF = a.readF()
    let rDC = a.readDC()
    println("rF=${rF}, rDC=${rDC}")
    if (rF == 42 && rDC == 42) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
