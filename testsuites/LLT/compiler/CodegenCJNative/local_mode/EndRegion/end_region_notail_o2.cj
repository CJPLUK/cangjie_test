// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 看护：-O2 下内层函数的 local region 结束不得波及外层的 local region。
//
// 若 CJ_MCC_EndLocalRegion 在 O2 流水线中被尾调用化（cjc 未标记 notail，
// 或 llvm 侧 TCE 未保留 notail），桩会以"调用者"的帧指针关闭上层 region，
// 外层函数的 local 对象在外层 region 结束前就失去保护；随后的 GC 压力
// （大量堆分配触发回收）可能回收或迁移该对象，导致错误结果或崩溃。
//
// outer 先建立 local region 并持有 Box @local!，再两次调用 inner（内层
// 自开自关 region），中间插入 garbage() 堆分配压力触发 GC；若外层 region
// 被提前关闭，最后读取 b.v 时可能得到坏数据。
// 端到端正确结果：20 + 7 + 0 = 27。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt -O2 %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan region keep: 27

class Box {
    var v: Int64
    init(this @~local, x: Int64) { v = x }
    exclave init(this @local!, x: Int64) { v = x }
}

var sink: Int64 = 0

func inner(x: Int64): Unit {
    let b: Box @local! = Box(x)
    sink = b.v
}

func garbage(n: Int64): Int64 {
    var s: Int64 = 0
    var i: Int64 = 0
    while (i < n) {
        let g = Box(i)
        s += g.v
        i += 1
    }
    return s
}

func outer(): Int64 {
    let b: Box @local! = Box(20)
    inner(5)
    let g = garbage(1000000)
    inner(7)
    let adj = if (g >= 0) { 0 } else { 1 }
    return b.v + sink + adj
}

main(): Int64 {
    println("region keep: ${outer()}")
    return 0
}
