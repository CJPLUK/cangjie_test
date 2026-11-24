// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 带 demode 字段的 struct 写入 local 数组的聚合元素写屏障分类。
// local! struct 的 demode 字段合法持有堆对象，因此 `Array<S> @local!` 的元素槽
// 是 region->heap 边：逐元素下标赋值（CallArrayIntrinsicSet sized-struct 分支）
// 与 repeat 构造（InitArrayData）必须透传 writeKind 走 maybe.local.write.struct
// 登记堆槽位。若退回普通 gcwrite.struct，翻搅后经 demode 字段读回的堆对象将
// 悬垂。字面量初始化路径（CallArrayIntrinsicInitWithContent）已模态感知，此处
// 看护的是同一根因的另外两条聚合路径。
// 断言：
//   1) 用户侧字面量元素写产生 maybe.local.write.struct（2 次调用 + 1 条
//      声明）；下标赋值与 repeat 构造经 stdlib 媒介（其泛型屏障运行期分派），
//   2) 端到端结果正确（GC 翻搅后经 demode 字段读回 7/7/7）。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-3 llvm.cj.maybe.local.write.struct

class Cell {
    var v: Int64
    init(x: Int64) { v = x }
}
struct S {
    demode var c: Cell
    init(this @~local) { c = Cell(5) }
    init(this @local!) { exclave { c = Cell(7) } }
}
func churn(n: Int64): Unit {
    var i: Int64 = 0
    while (i < n) { let t = Cell(9); i += 1 }
}
func fill(a: Array<S> @local!): Unit {
    exclave { a[1] = S() @local! }
}
class Driver {
    var a: Array<S>
    var b: Array<S>
    exclave init(this @ local!) {
        a = [S() @local!, S() @local!]
        b = Array<S>(2, repeat: S() @local!)
    }
    func run(this @ local!): Unit {
        exclave {
            fill(a)
            a[0] = S() @local!
            b[1] = S() @local!
            churn(2000000)
            println("r=${a[0].c.v} ${a[1].c.v} ${b[1].c.v}")
            if (a[0].c.v == 7 && a[1].c.v == 7 && b[1].c.v == 7) {
                println("GOOD")
            } else {
                println("BAD")
            }
        }
    }
}
main(): Int64 {
    let d = Driver() @local!
    d.run()
    return 0
}
