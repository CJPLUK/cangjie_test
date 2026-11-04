// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: compute 的双实现同包编译进应用二进制，由 @IfAvailable 运行期门控二选一。
//   - computeLocal：local-mode 实现（local! 对象、local 数组、跨函数传递 local! 引用），
//     编译后应用二进制会引用 CJ_MCC_NewLocalObject/NewLocalArray*/StartLocalRegion 等
//     local 特有运行时符号——这些符号只存在于新 runtime，旧（内核下沉）runtime 中缺失，
//     因此内核环境必须依赖动态链接懒解析保证"未进入的分支不会被解析"；
//   - computeHeap：无 local-mode 语义的等价实现，任何环境可用。
//   两实现共用包名 cpu 与一致的返回契约（20+22=42），保证分支切换只改变实现路径、不改变结果。

package cpu

public class Node {
    public var v: Int64
    public init(this @~local, x: Int64) { v = x }
    public exclave init(this @local!, x: Int64) { v = x }
}

public exclave func sumLocal(a: Node @local!, b: Node @local!): Int64 {
    var arr: Array<Node> @local! = [a, b]
    let x: Node @local! = arr[0]
    let y: Node @local! = arr[1]
    return x.v + y.v
}

public func computeLocal(): Int64 {
    let a: Node @local! = Node(20) @local!
    let b: Node @local! = Node(22) @local!
    return sumLocal(a, b)
}

public func computeHeap(): Int64 {
    let a = Node(50)
    let b = Node(52)
    return a.v + b.v
}
