// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: local? 数组的引用型元素写入必须走 local-aware 写屏障（回归用例，覆盖 issue #1318）。
// 场景：Array<Cell> @local? 字面量初始化。backing array 经 llvm.cj.malloc.local.array
// 分配在 local region，元素是 heap 对象；该 region->heap 引用边必须登记到
// LocalObjectRootRegistry，否则 GC 只看 heap 侧可达性时会把未被登记的 Cell 当垃圾
// 回收，翻搅后 a[i].v 读到被复用内存（输出翻搅值 9）。
// 数组基类型不是 nominal CustomType，ClassifyModalWrite 不能走成员变量路径，
// 必须直接按数组类型判定：local 数组 + 含引用元素 => maybe.local.write.ref。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var v: Int64
    init(x: Int64) { v = x }
}

main(): Int64 {
    let a: Array<Cell> @local? = [Cell(42), Cell(43), Cell(44)]
    var i: Int64 = 0
    while (i < 2000000) {
        let g = Cell(9)
        i += 1
    }
    let r0 = a[0].v
    let r2 = a[2].v
    println("r0=${r0}, r2=${r2}")
    if (r0 == 42 && r2 == 44) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
