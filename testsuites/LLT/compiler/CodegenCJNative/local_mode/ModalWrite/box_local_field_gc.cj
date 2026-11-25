// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: Copyable struct 装箱为 interface 后写入 local! class 的实例成员必须可 GC 存活
// （回归用例，覆盖 issue #1348 的合法形态）。
// 场景：c: C @local! 的成员 x: I（interface）被赋值为 S(42) 的装箱对象。CHIR 中
// Box 表达式结果类型为 Class-I @local!，装箱分配必须与该模态一致（local box 或
// 在写入时登记 local root）；二者任一缺失，heap 装箱对象在翻搅后被回收、内存被
// Junk 复用，调用 c.x.get() 时查 itable 触发
// "extensionData is nullptr, ti: default:Junk, itf: default:I" SIGABRT。
// 注：issue 原始代码中 'c.x = S(42) @~local'（~local 值赋给 local! 成员）属于模态
// 不 incomparable 的非法赋值，当前前端已拒绝；本用例使用合法推断形态 S(42)。

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface I { func get(this @ local!): Int64 }
struct S <: I & Copyable {
    public let v: Int64
    public init(v: Int64) { this.v = v }
    public init(this @ local!, v: Int64) {
        exclave { this.v = v }
    }
    public func get(this @ local!): Int64 { return this.v }
}
class C {
    var x: I
    init(this @ local!) {
        exclave { x = S(-1) @local! }
    }
}
class Junk {
    var a: Int64
    init() { a = 119304647 }
}
main(): Int64 {
    let c = C() @local!
    c.x = S(42)
    var sum: Int64 = 0
    var i: Int64 = 0
    while (i < 2000000) {
        let j = Junk()
        sum = sum + j.a
        i = i + 1
    }
    let got = c.x.get()
    println("got=${got}")
    if (got == 42) {
        println("OK")
        return 0
    }
    println("BAD")
    return 1
}
