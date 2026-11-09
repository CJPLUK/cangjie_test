// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: local! 对象在真实 GC 压力下的存活性与遍历一致性（端到端行为用例）。
// 局部链表 2 万个 Node @local! 持续增长（分配期间不断触发年轻代回收）；随后在
// main 中制造约 40MB 大块垃圾（每轮 64KB 数组 x600）逼迫多轮 GC；最后重新遍历
// 整条 local 链。若 local root 登记（MaybeLocalWriteRef / local 数组路径 /
// local finalizer 注册）任一环节丢失，链中节点会被 GC 当作垃圾回收，重遍历时
// 读到被覆写的内存：要么崩溃，要么 sum 不等于 199990000。本用例锁定：
//   1) local 链在多轮 GC 后完整可遍历，节点数与总和精确一致；
//   2) 大块垃圾分配不会误伤 local region 对象（heap/local 互不踩踏）。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Node {
    var next: Option<Node>
    var v: Int64
    init(this @~local, x: Int64) {
        v = x
        next = None
    }
    exclave init(this @local!, x: Int64) {
        v = x
        next = None
    }
}

// 大块垃圾：每轮分配一个 64KB 数组，累计约 40MB，强制触发多轮 GC。
func garbage(rounds: Int64): Int64 {
    var acc: Int64 = 0
    for (i in 0..rounds) {
        let junk: Array<UInt8> = Array<UInt8>(65536, repeat: UInt8(i % 128))
        acc += Int64(junk[65535])
    }
    return acc
}

exclave func buildChain(head: Node @local!, n: Int64): Int64 {
    var tail: Node @local! = head
    var i: Int64 = 1
    while (i < n) {
        let cur: Node @local! = Node(i) @local!
        tail.next = Some(cur)
        tail = cur
        i += 1
    }
    return i
}

exclave func walkChain(head: Node @local!): Int64 {
    var sum: Int64 = 0
    var cur: Node @local! = head
    while (true) {
        sum += cur.v
        match (cur.next) {
            case Some(nx) => cur = nx
            case None => break
        }
    }
    return sum
}

main(): Int64 {
    let head: Node @local! = Node(0) @local!
    let n = buildChain(head, 20000)
    let g = garbage(600)
    let s = walkChain(head)
    println("s=${s} n=${n} g=${g % 128}")
    return if (s == 199990000 && n == 20000) { 0 } else { 1 }
}
