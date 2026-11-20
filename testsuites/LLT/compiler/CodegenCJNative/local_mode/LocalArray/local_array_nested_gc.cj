// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: local? 嵌套数组的外层元素写入必须登记 local root（回归用例，覆盖 issue #1316）。
// 场景：Array<Array<Int64>> @local? 字面量，内层数组是 heap 对象，被外层 local? backing
// array 的引用槽持有。若该槽位的写入退化为普通 gcwrite.ref，local root 登记表不会收录
// 该 region->heap 边，GC 翻搅后内层数组被回收，a[0][0] 读到被复用内存（输出指针值）。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Cell {
    var v: Int64
    init(x: Int64) { v = x }
}

main(): Int64 {
    let i0: Array<Int64> = [111, 1]
    let i1: Array<Int64> = [222, 2]
    let a: Array<Array<Int64>> @local? = [i0, i1, [333, 3]]
    var i: Int64 = 0
    while (i < 2000000) {
        let g = Cell(9)
        i += 1
    }
    let r0 = a[0][0]
    let r1 = a[1][0]
    println("r0=${r0} r1=${r1}")
    if (r0 == 111 && r1 == 222) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
