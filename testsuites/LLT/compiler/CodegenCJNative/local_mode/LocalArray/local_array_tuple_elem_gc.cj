// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: local? 数组的聚合（tuple）元素写入必须保持 local-aware 屏障类别
// （回归用例，覆盖 issue #1318 的元组场景）。
// 场景：Array<(Int64, Cell)> @local? 字面量。元素是含引用槽的 tuple，写入路径为
// StoreElementRef -> CreateStore -> EmitStructFieldWriteBarrier -> 聚合写屏障；
// 若分类退化为 NONE 或聚合写无条件落到普通 llvm.cj.gcwrite.struct，tuple 中的
// Cell 引用槽不会被登记，GC 翻搅后 t[i][1].v 读到被复用内存（输出 9）。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var v: Int64
    init(x: Int64) { v = x }
}

main(): Int64 {
    let t: Array<(Int64, Cell)> @local? = [(1, Cell(52)), (2, Cell(53)), (3, Cell(54))]
    var i: Int64 = 0
    while (i < 2000000) {
        let g = Cell(9)
        i += 1
    }
    let t0 = t[0][1].v
    let t2 = t[2][1].v
    println("t0=${t0}, t2=${t2}")
    if (t0 == 52 && t2 == 54) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
